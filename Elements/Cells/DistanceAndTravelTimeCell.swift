import UIKit
import MapKit

class DistanceAndTravelTimeCell: UITableViewCell {
    static let defaultIdentifier = "DistanceAndTravelTimeCellIdentifier"
    
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = ""
            distanceLabel.isHidden = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = ""
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
    private var locationProvider: LocationProvider!
    
    static func getCell() -> DistanceAndTravelTimeCell {
        return UINib(nibName: "DistanceAndTravelTimeCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DistanceAndTravelTimeCell
    }
    
    func set(with pass: Pass, locationProvider: LocationProvider) -> DistanceAndTravelTimeCell {
        self.pass = pass
        self.locationProvider = locationProvider
        self.selectionStyle = .none
        getDistanceAndTravelTime()
        return self
    }
    
    private func getDistanceAndTravelTime() {
        guard let userLocation = locationProvider.lastLocation else {
            print("DistanceAndTravelTimeCell.swift - No last location available")
            return
        }
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: pass.coordinates)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculateETA { [weak self] response, error in
            guard let directionResponse = response else {
                if let error = error as? MKError {
                    print("DistanceAndTravelTimeCell.swift - An error occurred when requesting ETA: \(error.localizedDescription)")
                    self?.setErrorLabel(with: error.localizedDescription)
                }
                return
            }
            
            self?.setLabels(withDistance: directionResponse.distance, andTime: directionResponse.expectedTravelTime)
        }
    }
    
    private func setLabels(withDistance distance: CLLocationDistance, andTime time: TimeInterval) {
        distanceLabel.text = formatDistance(from: distance)
        timeLabel.text = formatTime(from: time)
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        errorMessageLabel.isHidden = true
        
        distanceLabel.isHidden = false
        timeLabel.isHidden = false
        
        mapsButton.isHidden = false
    }
    
    private func formatDistance(from distance: CLLocationDistance) -> String {
        let distanceInKm = Measurement(value: distance, unit: UnitLength.meters).converted(to: .kilometers)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        
        formatter.numberFormatter = numberFormatter
        
        return formatter.string(from: distanceInKm)
    }
    
    private func formatTime(from time: TimeInterval) -> String! {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: time)
    }
    
    private func setErrorLabel(with message: String) {
        errorMessageLabel.text = message
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        distanceLabel.isHidden = true
        timeLabel.isHidden = true
        
        mapsButton.isHidden = true
        
        errorMessageLabel.isHidden = false
    }
    
    @IBAction func userDidTapMapsButton(_ sender: UIButton) {
        // TODO: add link to open Maps with directions
        print("button tapped")
    }
    
}

