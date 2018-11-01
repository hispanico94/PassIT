import UIKit

protocol CellRepresentable {
    func makeTableViewCell(for tableView: UITableView) -> UITableViewCell
}
