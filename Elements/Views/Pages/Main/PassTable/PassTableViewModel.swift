import UIKit
import RxSwift
import RxDataSources

struct PassTableViewModel {
    private let passes: [Pass]
    private let passSelectionHandler: ((Pass) -> Void)?
    private weak var navigationController: UINavigationController?
    
    init(passes: [Pass], navigationController: UINavigationController, passSelectionHandler: ((Pass) -> Void)?) {
        self.passes = passes
        self.passSelectionHandler = passSelectionHandler
        self.navigationController = navigationController
    }
    
    // Outputs
    
    var sectionedItems: Observable<[PassTableSection]> {
        return Observable.just(getSectionedItems())
    }
    
    // Inputs
    
    func passSelected(_ pass: Pass) {
        passSelectionHandler?(pass)
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

