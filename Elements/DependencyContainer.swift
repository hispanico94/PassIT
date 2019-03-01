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
        navigationController.viewControllers = [makeMainViewController(navigationController: navigationController)]
        return navigationController
    }
    
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController {
        return PassDetailsViewController(pass: pass, userLocation: userLocation.lastLocation)
    }
    
    private func makeMapViewController() -> MapViewController {
        let mapViewModel = MapViewModel(passes: passes, userLocation: userLocation.lastLocation)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        return mapViewController
    }
    
    private func makePassTableViewController(navigationController: UINavigationController?) -> PassTableViewController {
        let viewModel = PassTableViewModel(passes: passes, factory: self, navigationController: navigationController)
        let passTableViewController = PassTableViewController(viewModel: viewModel)
        return passTableViewController
    }
    
    private  func makeMainViewController(navigationController: UINavigationController) -> MainViewController {
        let mapVC = makeMapViewController()
        let passTableVC = makePassTableViewController(navigationController: navigationController)
        return MainViewController(mapViewController: mapVC, passTableViewController: passTableVC)
    }
}
