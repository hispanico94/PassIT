import CoreLocation
import RxSwift
import RxCocoa

class UserLocation {
    private let locationManager: CLLocationManager
    
    private var isLocalizationAuthorizedWhenInUse: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var lastLocation: Observable<CLLocation> {
        return locationRelay
            .filter { $0 != nil }
            .map { $0! }
            .asObservable()
            .share()
    }
    
    private var locationRelay: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        
        subscribeToLocationUpdate()
        subscribeToErrors()
        
        if isLocalizationAuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func subscribeToLocationUpdate() {
        locationManager.rx.didUpdateLocations
            .map { $0[0] }
            .debug("UserLocation.swift - didUpdateLocations")
            //.filter { $0.horizontalAccuracy < kCLLocationAccuracyHundredMeters }
            .subscribe(onNext: { [weak self] newLocation in
                self?.locationRelay.accept(newLocation)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeToErrors() {
        locationManager.rx.didFailWithError
            .do(onNext: { print("UserLocation.swift - LocationManager failed with error: \($0.localizedDescription)") })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
