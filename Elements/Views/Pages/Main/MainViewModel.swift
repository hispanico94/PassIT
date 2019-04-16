import MapKit
import RxSwift
import RxDataSources

struct MainViewModel {
    private let passes: [Pass]
    private let userLocation: Observable<CLLocation>
    
    private let initialRegionRadius: CLLocationDistance = 30000
    
    // Initializer
    
    init(passes: [Pass], userLocation: Observable<CLLocation>, passSelected: AnyObserver<Pass>) {
        self.passes = passes
        self.userLocation = userLocation
        self.passSelected = passSelected
    }
    
    // Outputs
    
    var sectionedItems: Observable<[PassTableSection]> {
        return Observable.just(getSectionedItems())
    }
    
    var items: Observable<[Pass]> {
        return Observable.just(passes)
    }
    
    var initialMapRegion: Observable<MKCoordinateRegion> {
        return userLocation
            .take(1)
            .map { location in
                return MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: self.initialRegionRadius,
                    longitudinalMeters: self.initialRegionRadius
                )
        }
    }
    
    // Inputs
    
    var passSelected: AnyObserver<Pass>
    
    
    // Private methods
    
    private func getSectionedItems() -> [PassTableSection] {
        return Region.allCases
            .sorted(by: their(^\Region.rawValue))
            .map { region in
                let passesOfRegion = passes.filter { $0.address.region == region }
                return PassTableSection(passes: passesOfRegion, title: region)
        }
    }
}
