import CoreLocation
import RxSwift
import RxCocoa

class UserLocation {
    private let locationManager: CLLocationManager
    
    private var isLocalizationAuthorizedWhenInUse: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var lastLocation: Observable<CLLocation?> {
        return locationRelay
            .asObservable()
            .share()
    }
    
    private var locationRelay: BehaviorRelay<CLLocation?> = BehaviorRelay.init(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        
        subscribeToLocationUpdate()
        
        if isLocalizationAuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func subscribeToLocationUpdate() {
        locationManager.rx.didUpdateLocations
            .map { $0[0] }
            .filter { $0.horizontalAccuracy < kCLLocationAccuracyHundredMeters }
            .subscribe(onNext: { [weak self] newLocation in
                self?.locationRelay.accept(newLocation)
                
            })
            .disposed(by: disposeBag)
    }
}
