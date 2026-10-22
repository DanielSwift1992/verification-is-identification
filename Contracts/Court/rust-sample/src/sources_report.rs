use crate::{Answer,Loader,context::Context,failure::Failure};
use std::collections::{HashMap,HashSet};
use serde_json::{json,Value};
#[derive(Clone)]
pub struct Row {pub path:String,pub source:String,pub outcome:String,pub equalities:usize,pub memberships:usize,pub readings:usize,pub unchecked:Vec<String>,pub diagnostics:Vec<String>}
impl Row {
    pub fn new(path:&str,source:&str)->Self {Self{path:path.into(),source:source.into(),outcome:"empty".into(),equalities:0,memberships:0,readings:0,unchecked:vec![],diagnostics:vec![]}}
    fn object(&self)->Value {json!({"path":self.path,"source":self.source,"outcome":self.outcome,"equalities":self.equalities,"memberships":self.memberships,"readings":self.readings,"unchecked":self.unchecked,"diagnostics":self.diagnostics})}
}
fn aggregate(rows:&[Row])->String {
    for outcome in ["unsupported","refused","not-established","holds"] {if rows.iter().any(|r|r.outcome==outcome){return outcome.into();}}
    "empty".into()
}
fn fail(message:String)->Failure {Failure::Input(vec![message])}
pub fn answer(load:Loader,arguments:&[String],question:&str)->Answer {
    let mut inputs=Vec::<Value>::new();let mut results=Vec::<Row>::new();let mut diagnostics=Vec::<String>::new();let mut outcome="unsupported".to_string();
    let attempt=(|| -> Result<(),Failure> {
        let mut paths=Vec::new();let mut context_path=None;let mut documents=HashSet::new();let mut options=HashMap::new();let mut reports=0;let mut i=0;
        while i<arguments.len(){
            let word=&arguments[i];
            if word=="--report" {reports+=1;i+=1;continue;}
            if word.starts_with("--") {
                if i+1>=arguments.len() || arguments[i+1].starts_with("--"){return Err(fail(format!("incomplete source reading option '{}'",word)));}
                let value=arguments[i+1].clone();
                if word=="--context" && context_path.is_none(){context_path=Some(value);}
                else if word=="--document" && documents.insert(value.clone()){}
                else if question=="count" && ["--predicate","--encoding","--sigma"].contains(&word.as_str()) && !options.contains_key(word){options.insert(word.clone(),value);}
                else {return Err(fail(format!("unsupported or duplicate source reading option '{}'",word)));}
                i+=2;
            } else {paths.push(word.clone());i+=1;}
        }
        if reports!=1 || context_path.is_none(){return Err(fail("source reading requires one --report and --context".into()));}
        let context_path=context_path.unwrap();let mut texts=HashMap::new();let mut ordered=paths.clone();ordered.push(context_path.clone());ordered.sort();
        for path in ordered {
            let raw=load(&path).map_err(|_|fail(format!("cannot read {}",path)))?;
            inputs.push(json!({"path":path,"sha256":crate::digest::sha256(raw.as_bytes())}));texts.insert(path,raw);
        }
        let context=Context::read(&texts[&context_path],&paths,&texts)?;
        if context.version!=2 {return Err(fail("--report requires vi.court.context/2".into()));}
        let mut own:Vec<_>=context.sources.iter().filter(|s|s.role=="own").collect();own.sort_by_key(|s|&s.input);
        if question=="where" && own.is_empty(){return Err(fail("where context has no own source".into()));}
        if !documents.is_subset(&own.iter().map(|s|s.input.clone()).collect()){return Err(fail("--document must name a distinct own source".into()));}
        if question=="where" {
            for source in own {
                let mut row=Row::new(&source.input,&source.source);
                let attempt=(|| -> Result<(),Failure> {
                    let ordered:Vec<_>=std::iter::once(source.input.clone()).chain(paths.iter().filter(|p|**p!=source.input).cloned()).collect();
                    let prepared=crate::context::prepare_read(&ordered,&context_path,&|p|Ok(texts[p].clone()),&documents,true,false)?;
                    row.unchecked=prepared.world.excluded_definitions.clone();
                    let answer=crate::where_judge::evaluate(&prepared)?;
                    row.equalities=answer.equalities;row.memberships=answer.memberships;row.diagnostics=answer.refusals;
                    row.outcome=if row.diagnostics.is_empty(){"holds"}else{"not-established"}.into();Ok(())
                })();
                if let Err(f)=attempt {row.outcome=match &f {Failure::Empty(_)=>"empty",Failure::Refused(_)=>"refused",Failure::Open(_)=>"not-established",_=>"unsupported"}.into();row.diagnostics=f.messages().to_vec();}
                results.push(row);
            }
        } else {results=crate::count_court::context_read(&context,&texts,&documents,&options)?;}
        outcome=aggregate(&results);Ok(())
    })();
    if let Err(f)=attempt {diagnostics=f.messages().to_vec();}
    results.sort_by(|a,b|a.path.cmp(&b.path));
    let object=json!({"schema":"vi.court.sources/1","question":question,"inputs":inputs,"outcome":outcome,"results":results.iter().map(Row::object).collect::<Vec<_>>(),"diagnostics":diagnostics});
    Answer{exit:if outcome=="holds"{0}else if ["refused","not-established"].contains(&outcome.as_str()){1}else{2},stdout:serde_json::to_string(&object).unwrap()+"\n",stderr:String::new()}
}
