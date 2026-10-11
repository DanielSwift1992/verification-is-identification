import Foundation
@main struct AcquisitionExport {
 static func main() throws {
    let dir=CommandLine.arguments[1], models=try acquisitionModels(), plans=try models.map(derive)
    let requests=try acquisitionRequests().map(chooseAcquisition)
    try writeJSON(["schema":"vi.acquisition.requests.v1","requests":requests],to:dir+"/requests.json")
    try ("import VerificationIsIdentification\n"+zip(models,plans).map(certificate).joined(separator:"\n"))
       .write(toFile:dir+"/Certificates.swift",atomically:true,encoding:.utf8)
    // The checked consumer derives request selection again from the CURRENT
    // source constructors. No active control or observed reply enters either export.
    let statement="try writeJSON([\"schema\":\"vi.acquisition.requests.v1\",\"requests\":try checkedAcquisitionRequests(acquisitionRequests(),sources:checkedSources)],to:dir+\"/requests.json\")\n"
    let second=checkedEmitter(models,plans,extraEmission:statement)
    try second.write(toFile:dir+"/CheckedExport.swift",atomically:true,encoding:.utf8)
 }
}
