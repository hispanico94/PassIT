import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let initialRegionRadius: CLLocationDistance = 20000
    
    let passes: [Pass]
    let locationProvider: LocationProvider
    
    init(passes: [Pass], locationProvider: LocationProvider) {
        self.passes = passes
        self.locationProvider = locationProvider
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
        
        if let userCoordinates = locationProvider.lastLocation?.coordinate {
            centerMap(onCoordinates: userCoordinates)
        }
    }
    
    private func centerMap(onCoordinates coordinates: CLLocationCoordinate2D) {
        let userRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: initialRegionRadius, longitudinalMeters: initialRegionRadius)
        mapView.setRegion(userRegion, animated: true)
    }
}
