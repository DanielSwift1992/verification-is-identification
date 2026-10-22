use crate::{context::{Context,Source}, expression::World, failure::Failure, lexical::*, notation::Notation, where_judge};
use std::collections::{HashMap,HashSet};
pub fn imports(text:&str,lent:&HashSet<String>)->Result<Vec<(String,usize)>,Failure> {
    Ok(strip_comments(text,lent)?.split('\n').enumerate().flat_map(|(index,line)|
        captures(r"\bimport\s+([^;\n]+)",line).into_iter().map(move |hit|(hit[0].trim().to_string(),index+1))
    ).collect())
}
pub fn count_questions(text:&str,path:&str,lent:&HashSet<String>)->Result<Vec<std::collections::BTreeMap<String,String>>,Failure> {
    let (view,_) = crate::definition_view::scoped(text,path,lent)?;
    let world=where_judge::read_version(&view,lent,true)?;
    let mut names:Vec<_>=world.conformers.keys().collect(); names.sort();
    let mut seen=HashSet::new();let mut result=Vec::new();
    for name in names {
        let conformer=&world.conformers[name];
        if !conformer.protocols.iter().any(|p|p=="PredicateReading"){continue;}
        if let (Some(predicate),Some(encoding),Some(sigma))=(conformer.table.get("Predicate"),conformer.table.get("Encoding"),conformer.table.get("Sigma")) {
            if seen.insert(vec![predicate.clone(),encoding.clone(),sigma.clone()]) {
                result.push([("predicate".into(),predicate.clone()),("encoding".into(),encoding.clone()),("sigma".into(),sigma.clone())].into_iter().collect());
            }
        }
    }
    Ok(result)
}
#[derive(Clone)]
pub struct File { pub context:Source,pub text:String,pub view:String,pub world:World,pub notation:Notation,pub excluded:Option<usize>,pub unchecked:Vec<String> }
pub fn read(context:&Context,texts:&HashMap<String,String>,selected:Option<&String>,documents:&HashSet<String>)->Result<Vec<File>,Failure> {
    let mut lent=HashSet::new();
    for text in texts.values() { if let Ok(clean)=strip_comments(text,&HashSet::new()) {lent.extend(declared_builders(&clean));} }
    let mut files=Vec::new();
    for source in &context.sources {
        let text=texts[&source.input].clone();
        let raw_own=(selected==Some(&source.input) || (selected.is_none() && source.role=="own")) && !documents.contains(&source.input);
        let (view,excluded)=if raw_own {(text.clone(),None)} else {if context.version==2 {crate::definition_view::scoped(&text,&source.source,&lent)?} else {crate::definition_view::read(&text,&source.source,&lent)?}};
        let world=where_judge::read_version(&view,&lent,context.version==2)?;
        for (imported,line) in imports(&view,&lent)? {
            if !source.imports.contains(&imported) {return crate::failure::fail(format!("{}:{}: import '{}' is not declared by the source context",source.source,line,imported));}
        }
        let notation=Notation::new(&world.clean)?;
        let mut unchecked:Vec<String>=excluded.map(|line|vec![format!("{}:{}",source.source,line)]).unwrap_or_default();
        if context.version==2 {
            for (index,line) in blank_comments_and_strings(&text,&lent)?.split('\n').enumerate(){
                if re(r"^\s*#if\b").is_match(line){unchecked.push(format!("{}:{} (conditional compilation)",source.source,index+1));}
            }
        }
        unchecked.sort();
        files.push(File {context:source.clone(),text,view,world,notation,excluded,unchecked});
    }
    Ok(files)
}
