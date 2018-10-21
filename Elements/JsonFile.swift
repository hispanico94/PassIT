struct JsonFile: Codable {
    let version: Int
    let passes: [Pass]
}
