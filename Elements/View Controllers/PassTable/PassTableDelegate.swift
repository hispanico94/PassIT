import UIKit

class PassTableDelegate: NSObject, UITableViewDelegate {
    let locationProvider: LocationProvider
    
    var cellSelectionHandler: ((UIViewController) -> ())?
    
    init(locationProvider: LocationProvider) {
        self.locationProvider = locationProvider
        super.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PassCell,
            let pass = cell.pass,
            let handler = cellSelectionHandler {
            let passDetailsViewController = PassDetailsViewController(pass: pass, locationProvider: locationProvider)
            handler(passDetailsViewController)
        }
    }
}
