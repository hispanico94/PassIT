import UIKit
import RxSwift

protocol ViewControllerFactory {
    func makePassDetailsViewController(with pass: Pass) -> PassDetailsViewController
    func makeMainViewController(mainViewModel: MainViewModel) -> MainViewController
}

protocol ViewModelFactory {
    func makeMainViewModel(passSelected: AnyObserver<Pass>) -> MainViewModel
}
