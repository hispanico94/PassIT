import UIKit
import CoreLocation

class DetailAccessoryView: UIView {
    
    @IBOutlet weak var elevationLabel: UILabel! {
        didSet {
            elevationLabel.text = "Elevation:"
        }
    }
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = "Address:"
        }
    }
    @IBOutlet weak var coordinatesLabel: UILabel! {
        didSet {
            coordinatesLabel.text = "Coordinates:"
        }
    }
    
    @IBOutlet weak var elevationDescriptionLabel: UILabel!
    @IBOutlet weak var addressDescriptionLabel: UILabel!
    @IBOutlet weak var coordinatesDescriptionLabel: UILabel!
    
    func configure(elevation: String?, address: String, coordinates: CLLocationCoordinate2D) {
        elevationDescriptionLabel.text = elevation ?? "---"
        coordinatesDescriptionLabel.text = "\(coordinates.latitude), \(coordinates.longitude)"
        addressDescriptionLabel.text = address
    }
}
