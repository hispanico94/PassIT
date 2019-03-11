import UIKit
import RxSwift

class DependencyContainer {
    private lazy var passes = JsonFile.getPasses()
    private lazy var userLocation = UserLocation()
}

// MARK: - ViewControllerFactory conformance

extension DependencyContainer: ViewControllerFactory {
    
    func makeMainViewController(mainViewModel: MainViewModel) -> MainViewController {
        return MainViewController(viewModel: mainViewModel)
    }
    
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController {
        return PassDetailsViewController(pass: pass, userLocation: userLocation.lastLocation)
    }
}

// MARK: - ViewModelFactory conformance

extension DependencyContainer: ViewModelFactory {    
    func makeMainViewModel(passSelected: AnyObserver<Pass>) -> MainViewModel {
        return MainViewModel(passes: passes, userLocation: userLocation.lastLocation, passSelected: passSelected)
    }
}
