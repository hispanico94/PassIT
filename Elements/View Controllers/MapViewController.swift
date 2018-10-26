import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let initialRegionRadius: CLLocationDistance = 20000
    
    let passes: [Pass]
    
    init(passes: [Pass]) {
        self.passes = passes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        
        mapView.register(PassMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let passesAnnotations = passes.map(PassAnnotation.init)
        mapView.addAnnotations(passesAnnotations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAndAuthorization()
    }

    private func checkLocationAndAuthorization() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func centerMap(onCoordinates coordinates: CLLocationCoordinate2D) {
        let userRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: initialRegionRadius, longitudinalMeters: initialRegionRadius)
        mapView.setRegion(userRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation =  locations.first!
        centerMap(onCoordinates: userLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clError = error as! CLError
        print(clError.localizedDescription)
    }
}
