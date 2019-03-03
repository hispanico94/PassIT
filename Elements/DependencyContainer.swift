import UIKit
import RxSwift

class DependencyContainer {
    private lazy var passes = JsonFile.getPasses()
    private lazy var userLocation = UserLocation()
}

// MARK: - ViewControllerFactory conformance

extension DependencyContainer: ViewControllerFactory {
    func makeMainViewController(mapViewModel: MapViewModel, passTableViewModel: PassTableViewModel) -> MainViewController {
        let mapVC = MapViewController(viewModel: mapViewModel)
        let passTableVC = PassTableViewController(viewModel: passTableViewModel)
        return MainViewController(mapViewController: mapVC, passTableViewController: passTableVC)
    }
    
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController {
        return PassDetailsViewController(pass: pass, userLocation: userLocation.lastLocation)
    }
}

// MARK: - ViewModelFactory conformance

extension DependencyContainer: ViewModelFactory {
    func makeMapViewModel() -> MapViewModel {
        return MapViewModel(passes: passes, userLocation: userLocation.lastLocation)
    }
    
    func makePassTableViewModel(passSelected: AnyObserver<Pass>) -> PassTableViewModel {
        return PassTableViewModel(passes: passes, passSelected: passSelected)
    }
    
    
}
