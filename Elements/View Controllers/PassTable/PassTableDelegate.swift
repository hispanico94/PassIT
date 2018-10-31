import UIKit

class PassTableDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PassCell, let pass = cell.pass {
            print("Selected cell: \(pass.id) - \(pass.name)")
        }
    }
}
