import Foundation
@main struct Export {
 static func main() throws {
    let dir=CommandLine.arguments[1]
    let models=try baseModels() + extraModels()
    let plans=try models.map(derive)
    try writeJSON(["schema":"vi.braket.sources.v1","control_count":4,"models":models.map(\.json)],to:dir+"/sources.json")
    try writeJSON(["schema":"vi.braket.audit.v1","plans":zip(models,plans).map { m,p in
      ["name":m.name,"exact":p.exact,"loss_numerator":p.loss,"loss_denominator":p.total,
       "measure":m.question == "State" ? "optimal half-diamond distance in the classical Pauli-record model" : "worst-case output probability error",
       "witness_rows":p.witness ?? []] as [String:Any]
    }],to:dir+"/audit.json")
    let cert="import VerificationIsIdentification\n"+zip(models,plans).map(certificate).joined(separator:"\n")
    try cert.write(toFile:dir+"/Certificates.swift",atomically:true,encoding:.utf8)
    try checkedEmitter(models,plans).write(toFile:dir+"/CheckedExport.swift",atomically:true,encoding:.utf8)
 }
}
