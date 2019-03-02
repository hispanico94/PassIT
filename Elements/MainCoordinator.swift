import UIKit
import RxSwift

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController
    private let factory: ViewModelFactory & ViewControllerFactory = DependencyContainer()
    
    private let disposeBag = DisposeBag()
    private let passSelected = PublishSubject<Pass>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewModel = factory.makeMapViewModel()
        let passTableViewModel = factory.makePassTableViewModel(navigationController: navigationController, passSelected: passSelected.asObserver())
        let mainVC = factory.makeMainViewController(navigationController: navigationController,
                                                    mapViewModel: mapViewModel,
                                                    passTableViewModel: passTableViewModel)
        bindPassSelection()
        
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    private func bindPassSelection() {
        passSelected
            .asObservable()
            .subscribe(onNext: { [weak self] pass in
                self?.passSelected(pass)
            })
            .disposed(by: disposeBag)
    }
    
    private func passSelected(_ pass: Pass) {
        let passDetailsVC = factory.makePassDetailsViewController(with: pass)
        navigationController.pushViewController(passDetailsVC, animated: true)
    }
    
}
