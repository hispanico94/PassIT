import UIKit

class DependencyContainer {
    private lazy var passes = JsonFile.getPasses()
    private lazy var userLocation = UserLocation()
}

protocol ViewControllerFactory {
    func makeInitialViewControllers() -> UIViewController
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
}



extension DependencyContainer: ViewControllerFactory {
    func makeInitialViewControllers() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [makePassTableViewController(navigationController: navigationController)]
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeMapViewController(), navigationController]
        
        return tabBarController
    }
    
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController {
        return PassDetailsViewController(pass: pass, userLocation: userLocation.lastLocation)
    }
    
    private func makeMapViewController() -> MapViewController {
        let mapViewModel = MapViewModel(passes: passes, userLocation: userLocation.lastLocation)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map_tab_bar_icon"), tag: 0)
        return mapViewController
    }
    
    private func makePassTableViewController(navigationController: UINavigationController) -> PassTableViewController {
        let viewModel = PassTableViewModel(passes: passes, factory: self, navigationController: navigationController)
        let passTableViewController = PassTableViewController(viewModel: viewModel)
        passTableViewController.title = "Passes and Peaks"
        passTableViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list_tab_bar_icon"), tag: 1)
        return passTableViewController
    }
}
