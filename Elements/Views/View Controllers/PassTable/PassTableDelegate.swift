import UIKit

class PassTableDelegate: NSObject, UITableViewDelegate {
    let factory: ViewControllerFactory
    
    var cellSelectionHandler: ((UIViewController) -> ())?
    
    init(factory: ViewControllerFactory) {
        self.factory = factory
        super.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if
            let cell = tableView.cellForRow(at: indexPath) as? PassCell,
            let pass = cell.pass,
            let handler = cellSelectionHandler {
                let passDetailsViewController = factory.makePassDetailsViewController(with: pass)
                handler(passDetailsViewController)
        }
    }
}
