import UIKit
import RxSwift

protocol ViewControllerFactory {
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
    func makeMainViewController(navigationController: UINavigationController, mapViewModel: MapViewModel, passTableViewModel: PassTableViewModel) -> MainViewController
}

protocol ViewModelFactory {
    func makeMapViewModel() -> MapViewModel
    func makePassTableViewModel(navigationController: UINavigationController, passSelected: AnyObserver<Pass>) -> PassTableViewModel
}
