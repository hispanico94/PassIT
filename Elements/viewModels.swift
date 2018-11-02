import UIKit
import CoreLocation

struct Section {
    let title: String
    let rows: [CellRepresentable]
}

struct DataRow {
    let key: String
    let value: String
}

struct MapRow {
    let coordinates: CLLocationCoordinate2D
}

// MARK: - Conforming to CellRepresentable

extension DataRow: CellRepresentable {
    func makeTableViewCell(for tableView: UITableView) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: DataCell.defaultIdentifier) as? DataCell
        let cell = dequedCell ?? DataCell.getCell()
        return cell.set(with: self)
    }
}

extension MapRow: CellRepresentable {
    func makeTableViewCell(for tableView: UITableView) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: MapCell.defaultIdentifier) as? MapCell
        let cell = dequedCell ?? DataCell.getCell()
        
        // TODO: set the cell
        
        return cell
    }
    
    
}
