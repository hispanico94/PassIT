import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController
    private let factory: ViewModelFactory & ViewControllerFactory = DependencyContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewModel = factory.makeMapViewModel()
        let passTableViewModel = factory.makePassTableViewModel(navigationController: navigationController) { [weak self] pass in
            self?.passSelected(pass)
        }
        let mainVC = factory.makeMainViewController(navigationController: navigationController,
                                                    mapViewModel: mapViewModel,
                                                    passTableViewModel: passTableViewModel)
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    private func passSelected(_ pass: Pass) {
        let passDetailsVC = factory.makePassDetailsViewController(with: pass)
        navigationController.pushViewController(passDetailsVC, animated: true)
    }
    
}
