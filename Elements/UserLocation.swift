import CoreLocation
import RxSwift
import RxCocoa

class UserLocation {
    private let locationManager = CLLocationManager()
        |> (prop(\.desiredAccuracy)) { _ in kCLLocationAccuracyHundredMeters}
        <> (prop(\.distanceFilter)) { _ in 100 }
    
    private var isLocalizationAuthorizedWhenInUse: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var lastLocation: Observable<CLLocation> {
        return locationRelay
            .compactMap { $0 }
            .asObservable()
            .share()
    }
    
    private var locationRelay: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init() {
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
