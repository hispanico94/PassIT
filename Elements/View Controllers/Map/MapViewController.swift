import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let initialRegionRadius: CLLocationDistance = 30000
    
    let passes: [Pass]
    let userLocation: Observable<CLLocation?>
    
    let disposeBag = DisposeBag()
    
    init(passes: [Pass], userLocation: Observable<CLLocation?>) {
        self.passes = passes
        self.userLocation = userLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(PassMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let passesAnnotations = passes.map(PassAnnotation.init)
        mapView.addAnnotations(passesAnnotations)
        
        mapView.showsUserLocation = true
        
        userLocation
            .filter { $0 != nil }
            .map { $0! }
            .take(1)
            .map { [unowned self] location in
                return MKCoordinateRegion(center: location.coordinate,
                                          latitudinalMeters: self.initialRegionRadius,
                                          longitudinalMeters: self.initialRegionRadius)
            }
            .bind(to: mapView.rx.region)
            .disposed(by: disposeBag)
    }
}
