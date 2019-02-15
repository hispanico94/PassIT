import Foundation
import CoreLocation
import UIKit
import RxSwift

struct Pass {
    let id: Int
    let name: String
    let coordinates: CLLocationCoordinate2D
    let elevation: Measurement<UnitLength>?
    let type: PassType?
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinates
        case elevation
        case type
        case address
    }
    
    enum CoordinatesKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

enum PassType: String {
    case pass
    case peak
}

struct Address: Codable {
    let road: String
    let municipality: String
    let province: String
    let region: Region
    
    enum CodingKeys: String, CodingKey {
        case road
        case municipality
        case province
        case region
    }
}

enum Region: String, Codable, CaseIterable {
    case valleAosta = "Valle d'Aosta"
    case piemonte = "Piemonte"
    case liguria = "Liguria"
    case lombardia = "Lombardia"
    case trentinoAltoAdige = "Trentino-Alto Adige"
    case veneto = "Veneto"
    case friuliVeneziaGiulia = "Friuli-Venezia Giulia"
    case emiliaRomagna = "Emilia-Romagna"
    case toscana = "Toscana"
    case umbria = "Umbria"
    case marche = "Marche"
    case lazio = "Lazio"
    case abruzzo = "Abruzzo"
    case molise = "Molise"
    case campania = "Campania"
    case basilicata = "Basilicata"
    case puglia = "Puglia"
    case calabria = "Calabria"
    case sicilia = "Sicilia"
    case sardegna = "Sardegna"
    
    var abbreviated: String {
        switch self {
        case .valleAosta:
            return "VdA"
        case .piemonte:
            return "Pie"
        case .liguria:
            return "Lig"
        case .lombardia:
            return "Lom"
        case .trentinoAltoAdige:
            return "TAA"
        case .veneto:
            return "Ven"
        case .friuliVeneziaGiulia:
            return "FVG"
        case .emiliaRomagna:
            return "EmR"
        case .toscana:
            return "Tos"
        case .umbria:
            return "Umb"
        case .marche:
            return "Mar"
        case .lazio:
            return "Laz"
        case .abruzzo:
            return "Abr"
        case .molise:
            return "Mol"
        case .campania:
            return "Cam"
        case .basilicata:
            return "Bas"
        case .puglia:
            return "Pug"
        case .calabria:
            return "Cal"
        case .sicilia:
            return "Sic"
        case .sardegna:
            return "Sar"
        }
    }
}

// MARK: - Conforming to Codable protocol

extension Pass: Codable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        
        let coordinatesValues = try values.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        let latitude = try coordinatesValues.decode(Double.self, forKey: .latitude)
        let longitude = try coordinatesValues.decode(Double.self, forKey: .longitude)
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if let elevationDouble = try values.decodeIfPresent(Double.self, forKey: .elevation) {
            self.elevation = Measurement<UnitLength>(value: elevationDouble, unit: .meters)
        } else {
            self.elevation = nil
        }
        
        let typeString = try values.decode(String.self, forKey: .type)
        self.type = PassType(rawValue: typeString)
        
        let addressValues = try values.nestedContainer(keyedBy: Address.CodingKeys.self, forKey: .address)
        let road = try addressValues.decode(String.self, forKey: .road)
        let municipality = try addressValues.decode(String.self, forKey: .municipality)
        let province = try addressValues.decode(String.self, forKey: .province)
        let region = try addressValues.decode(Region.self, forKey: .region)
        self.address = Address(road: road, municipality: municipality, province: province, region: region)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(elevation?.value, forKey: .elevation)
        try container.encode(type?.rawValue, forKey: .type)
        
        var coordinatesContainer = container.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        try coordinatesContainer.encode(coordinates.latitude, forKey: .latitude)
        try coordinatesContainer.encode(coordinates.longitude, forKey: .longitude)
        
        var addressContainer = container.nestedContainer(keyedBy: Address.CodingKeys.self, forKey: .address)
        try addressContainer.encode(address.road, forKey: .road)
        try addressContainer.encode(address.municipality, forKey: .municipality)
        try addressContainer.encode(address.province, forKey: .province)
        try addressContainer.encode(address.region, forKey: .region)
    }
}

// MARK: -

extension Address: CustomStringConvertible {
    var description: String {
        return "\(road), \(municipality) (\(province))"
    }
}

extension PassType: CustomStringConvertible {
    var description: String {
        switch self {
        case .pass:
            return "Pass"
        case .peak:
            return "Mountaintop road"
        }
    }
}

extension Pass {
    func getDataForDisplayInTableView(userLocation: Observable<CLLocation>) -> [Section] {
        let infoSection = getInformationsSection()
        let distanceAndTravelTimeSection = getDistanceAndTravelTimeSection(userLocation: userLocation)
        let mapSection = getMapSection()
        return [infoSection, distanceAndTravelTimeSection, mapSection]
    }
    
    private func getInformationsSection() -> Section {
        var rows = [CellRepresentable]()
        
        if let elevation = elevation {
            let elevationRow = DataRow(key: "Elevation:", value: elevation.integerDescription)
            rows.append(elevationRow)
        }
        if let type = type {
            let typeRow = DataRow(key: "Type:", value: type.description)
            rows.append(typeRow)
        }
        let addressRow = DataRow(key: "Address:", value: address.description)
        rows.append(addressRow)
        
        return Section(title: "Informations", rows: rows)
    }
    
    private func getMapSection() -> Section {
        let mapRow = MapRow(pass: self)
        return Section(title: "Map", rows: [mapRow])
    }
    
    private func getDistanceAndTravelTimeSection(userLocation: Observable<CLLocation>) -> Section {
        let distanceAndTravelTimeRow = DistanceAndTravelTimeRow(pass: self, userLocation: userLocation)
        return Section(title: "Distance and Travel Time", rows: [distanceAndTravelTimeRow])
    }
}

/*
 struct Section {
 let title: String
 let rows: [CellRepresentable]
 }
 
 struct DataRow {
 let key: String
 let value: String
 }
 */
