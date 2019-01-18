import Foundation
import CoreLocation

protocol LocationProvider {
    var lastLocation: CLLocation? { get }
    func notifyOnLocationChange(identifier: String, _ callback: @escaping (CLLocation) -> Void)
    func removeNotificationOnLocationChange(identifier: String)
}

class UserLocation: NSObject {
    let locationManager = CLLocationManager()
    
    private var isAuthorizedLocalizationWhenInUse: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    private(set) var lastLocation: CLLocation? {
        didSet {
            guard let lastLocation = lastLocation else { return }
            callbacks.values.forEach { $0(lastLocation) }
        }
    }
    
    private var callbacks: [String: (CLLocation) -> Void] = [:]
    
    override init() {
        super.init()
        setLocationManager()
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        
        if isAuthorizedLocalizationWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension UserLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clError = error as! CLError
        print("UserLocation.LocationManager error: \(clError.localizedDescription)")
    }
}

extension UserLocation: LocationProvider {
    func notifyOnLocationChange(identifier: String, _ callback: @escaping (CLLocation) -> Void) {
        callbacks[identifier] = callback
    }
    func removeNotificationOnLocationChange(identifier: String) {
        callbacks[identifier] = nil
    }
}
