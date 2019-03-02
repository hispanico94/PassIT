import UIKit

protocol ViewControllerFactory {
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
    func makeMainViewController(navigationController: UINavigationController, mapViewModel: MapViewModel, passTableViewModel: PassTableViewModel) -> MainViewController
}

protocol ViewModelFactory {
    func makeMapViewModel() -> MapViewModel
    func makePassTableViewModel(navigationController: UINavigationController, passSelectionHandler: ((Pass) -> Void)?) -> PassTableViewModel
}
