import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let initialRegionRadius: CLLocationDistance = 20000
    
    var passes: [Pass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
        
        mapView.register(PassMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        passes = getPassesFromJson()
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
    
    private func getPassesFromJson() -> [Pass] {
        guard let filePath = Bundle.main.path(forResource: "Passes", ofType: ".json") else { return [] }
        let url = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonFile = try JSONDecoder().decode(JsonFile.self, from: data)
            return jsonFile.passes
        } catch {
            print(error)
        }
        return []
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
