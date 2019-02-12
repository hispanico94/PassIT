import UIKit

class DependencyContainer {
    private lazy var passes = getPasses()
    private var userLocation = UserLocation()
}

protocol ViewControllerFactory {
    func makeInitialViewControllers() -> UIViewController
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
}



extension DependencyContainer: ViewControllerFactory {
    func makeInitialViewControllers() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: makePassTableViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeMapViewController(), navigationController]
        
        return tabBarController
    }
    
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController {
        return PassDetailsViewController(pass: pass, userLocation: userLocation.lastLocation)
    }
    
    private func makeMapViewController() -> MapViewController {
        let mapViewController = MapViewController(passes: passes, userLocation: userLocation.lastLocation)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map_tab_bar_icon"), tag: 0)
        return mapViewController
    }
    
    private func makePassTableViewController() -> PassTableViewController {
        let dataSource = PassTableDataSource(passes: passes)
        let delegate = PassTableDelegate(factory: self)
        let passTableViewController = PassTableViewController(dataSource: dataSource, delegate: delegate)
        passTableViewController.title = "Passes and Peaks"
        passTableViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list_tab_bar_icon"), tag: 1)
        return passTableViewController
    }
}
