import UIKit
import RxSwift

protocol ViewControllerFactory {
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
    func makeMainViewController(mapViewModel: MapViewModel, passTableViewModel: PassTableViewModel) -> MainViewController
}

protocol ViewModelFactory {
    func makeMapViewModel() -> MapViewModel
    func makePassTableViewModel(passSelected: AnyObserver<Pass>) -> PassTableViewModel
}
