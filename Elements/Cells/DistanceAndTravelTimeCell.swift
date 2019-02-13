import UIKit
import MapKit
import RxSwift
import RxCocoa

class DistanceAndTravelTimeCell: UITableViewCell {
    static let defaultIdentifier = "DistanceAndTravelTimeCellIdentifier"
    
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.isHidden = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.isHidden = true
        }
    }
    @IBOutlet weak var mapsButton: UIButton! {
        didSet {
            mapsButton.setBackgroundImage(UIImage(named: "maps_icon"), for: .normal)
            mapsButton.isHidden = true
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet {
            errorMessageLabel.isHidden = true
        }
    }
    
    private var pass: Pass!
    private var userLocation: Observable<CLLocation>!
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    static func getCell() -> DistanceAndTravelTimeCell {
        return UINib(nibName: "DistanceAndTravelTimeCell", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! DistanceAndTravelTimeCell
    }
    
    func set(with pass: Pass, userLocation: Observable<CLLocation>) -> DistanceAndTravelTimeCell {
        self.pass = pass
        self.userLocation = userLocation
        self.selectionStyle = .none
        getDistanceAndTravelTime()
        return self
    }
    
    private func getDistanceAndTravelTime() {
        
        let distanceAndTime = userLocation
            .take(1)
            .map { [weak self] location in
                return makeDirectionRequest(from: location.coordinate, to: self?.pass.coordinates)
            }
            .filter { $0 != nil }
            .map { $0! }
            .flatMap { request in
                return MKDirections(request: request).rx
                    .calculateETA
                    .map(distanceAndTravelTime(_:))
                    .map(formatStrings(distance:travelTime:))
            }
            .observeOn(MainScheduler.instance)
            .share()
        
        distanceAndTime
            .map { $0.distance }
            .bind(to: distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        distanceAndTime
            .map { $0.travelTime }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        distanceAndTime
            .do(
                onError: { [weak self] error in
                    self?.errorMessageLabel.text = error.localizedDescription
                    self?.setLabels(requestSuccessful: false)
                },
                onCompleted: { [weak self] in
                    self?.setLabels(requestSuccessful: true)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setLabels(requestSuccessful: Bool) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        errorMessageLabel.isHidden = requestSuccessful ? true : false
        
        distanceLabel.isHidden = requestSuccessful ? false : true
        timeLabel.isHidden = requestSuccessful ? false : true
        mapsButton.isHidden = requestSuccessful ? false : true
    }
    
    @IBAction func userDidTapMapsButton(_ sender: UIButton) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: pass.coordinates))
        
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapTypeKey: NSNumber(value: MKMapType.standard.rawValue)
        ]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

private func makeDirectionRequest(from source: CLLocationCoordinate2D?, to destination: CLLocationCoordinate2D?) -> MKDirections.Request? {
    guard let source = source, let destination = destination else {
        return nil
    }
    let sourcePlacemark = MKPlacemark(coordinate: source)
    let destinationPlacemark = MKPlacemark(coordinate: destination)
    return MKDirections.Request.drivingDirections(from: sourcePlacemark, to: destinationPlacemark)
}

private func distanceAndTravelTime(_ response: MKDirections.ETAResponse) -> (CLLocationDistance, TimeInterval) {
    return (response.distance, response.expectedTravelTime)
}

private func formatStrings(distance: CLLocationDistance, travelTime: TimeInterval) -> (distance: String, travelTime: String) {
    
    func formatDistance(from distance: CLLocationDistance) -> String {
        let distanceInKm = Measurement(value: distance, unit: UnitLength.meters).converted(to: .kilometers)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        
        formatter.numberFormatter = numberFormatter
        
        return formatter.string(from: distanceInKm)
    }
    
    func formatTime(from time: TimeInterval) -> String! {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: time)
    }
    
    return (distance: formatDistance(from: distance), travelTime: formatTime(from: travelTime))
}
