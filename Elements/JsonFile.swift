import Foundation

struct JsonFile: Codable {
    let version: Int
    let passes: [Pass]
}

struct JsonReader {
    static func readJson() -> JsonFile {
        let wrappedUrl = Bundle.main.url(forResource: "Passes", withExtension: "json")
        
        guard let url = wrappedUrl else {
            fatalError("Unable to get the URL of Passes.json")
        }
        
        return getJsonFileFromJsonOrCrash(jsonUrl: url)
    }
    
    private static func getJsonFileFromJsonOrCrash(jsonUrl url: URL) -> JsonFile {
        do {
            let jsonData = try Data(contentsOf: url)
            let jsonFile = try JSONDecoder().decode(JsonFile.self, from: jsonData)
            return jsonFile
        } catch {
            fatalError("Error during reading of Passes.json: \(error.localizedDescription)")
        }
    }
}
