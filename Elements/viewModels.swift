import UIKit
import CoreLocation
import RxSwift

struct Section {
    let title: String
    let rows: [CellRepresentable]
}

struct DataRow {
    let key: String
    let value: String
}

struct MapRow {
    let pass: Pass
}

struct DistanceAndTravelTimeRow {
    let pass: Pass
    let userLocation: Observable<CLLocation?>
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
        let cell = dequedCell ?? MapCell.getCell()
        return cell.set(with: pass)
    }
}

extension DistanceAndTravelTimeRow: CellRepresentable {
    func makeTableViewCell(for tableView: UITableView) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: DistanceAndTravelTimeCell.defaultIdentifier) as? DistanceAndTravelTimeCell
        let cell = dequedCell ?? DistanceAndTravelTimeCell.getCell()
        return cell.set(with: pass, userLocation: userLocation)
    }
}
