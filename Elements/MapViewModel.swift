import MapKit
import RxSwift

struct MapViewModel {
    private let passes: [Pass]
    private let userLocation: Observable<CLLocation>
    
    private let initialRegionRadius: CLLocationDistance = 30000
    
    // Initializer
    
    init(passes: [Pass], userLocation: Observable<CLLocation>) {
        self.passes = passes
        self.userLocation = userLocation
    }
    
    // Outputs
    
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
    
    var annotations: Observable<[MKAnnotation]> {
        return Observable.create { observer in
            let annotations = self.passes.map(PassAnnotation.init)
            observer.onNext(annotations)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
