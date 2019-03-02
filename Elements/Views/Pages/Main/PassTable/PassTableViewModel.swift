import UIKit
import RxSwift
import RxDataSources

struct PassTableViewModel {
    private let passes: [Pass]
    private weak var navigationController: UINavigationController?
    
    init(passes: [Pass], navigationController: UINavigationController, passSelected: AnyObserver<Pass>) {
        self.passes = passes
        self.navigationController = navigationController
        self.passSelected = passSelected
    }
    
    // Outputs
    
    var sectionedItems: Observable<[PassTableSection]> {
        return Observable.just(getSectionedItems())
    }
    
    // Inputs
    
    var passSelected: AnyObserver<Pass>
    
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

