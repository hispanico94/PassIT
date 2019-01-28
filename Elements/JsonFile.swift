import Foundation

struct JsonFile: Codable {
    let version: Int
    let passes: [Pass]
    
    init?(fromJsonWithUrl url: URL) {
        do {
            let jsonData = try Data(contentsOf: url)
            self = try JSONDecoder().decode(JsonFile.self, from: jsonData)
        } catch {
            print("Error during reading of Passes.json: \(error.localizedDescription)")
            return nil
        }
    }
}

func getPasses() -> [Pass] {
    guard
        let url = Bundle.main.url(forResource: "Passes", withExtension: "json"),
        let jsonFile = JsonFile(fromJsonWithUrl: url)
        else {
            fatalError("Unable to get the JsonFile from Passes.json")
    }
    return jsonFile.passes
}
