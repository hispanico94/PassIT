import UIKit
import RxSwift
import RxDataSources

struct PassTableViewModel {
    private let passes: [Pass]
    private let factory: ViewControllerFactory
    private weak var navigationController: UINavigationController?
    
    init(passes: [Pass], factory: ViewControllerFactory, navigationController: UINavigationController) {
        self.passes = passes
        self.factory = factory
        self.navigationController = navigationController
    }
    
    // Outputs
    
    var sectionedItems: Observable<[PassTableSection]> {
        return Observable.just(getSectionedItems())
    }
    
    // Inputs
    
    func passSelected(_ pass: Pass) {
        let vc = factory.makePassDetailsViewController(with: pass)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Private methods
    
    private func getSectionedItems() -> [PassTableSection] {
        return Region.allCases
            .sorted { $0.rawValue < $1.rawValue }
            .map { region in
                let passesOfRegion = passes.filter { $0.address.region == region }
                return PassTableSection(passes: passesOfRegion, title: region)
        }
    }
}


struct PassTableSection {
    var header: Region
    var items: [Item]
    
    init(passes: [Pass], title: Region) {
        self.header = title
        self.items = passes
    }
    
}

extension PassTableSection: SectionModelType {
    typealias Item = Pass
    
    init(original: PassTableSection, items: [Pass]) {
        self = original
        self.items = items
    }
}

