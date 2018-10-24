import UIKit
import CoreLocation

class DetailAccessoryViewController: UIViewController {

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
    
    @IBOutlet weak var elevationDescriptionLabel: UILabel! {
        didSet {
            elevationDescriptionLabel.text = elevation ?? "---"
        }
    }
    @IBOutlet weak var addressDescriptionLabel: UILabel! {
        didSet {
            addressDescriptionLabel.text = address
        }
    }
    @IBOutlet weak var coordinatesDescriptionLabel: UILabel! {
        didSet {
            coordinatesDescriptionLabel.text = "\(coordinates.latitude), \(coordinates.longitude)"
        }
    }
    
    private let elevation: String?
    private let address: String
    private let coordinates: CLLocationCoordinate2D
    
    init(elevation: String?, address: String, coordinates: CLLocationCoordinate2D) {
        self.elevation = elevation
        self.address = address
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setElevation()
//        setAddress()
//        setCoordinates()
//    }

    private func setElevation() {
        elevationLabel.text = "Elevation:"
        elevationDescriptionLabel.text = elevation ?? "---"
    }
    
    private func setAddress() {
        addressLabel.text = "Address:"
        addressDescriptionLabel.text = address
    }
    
    private func setCoordinates() {
        coordinatesLabel.text = "Coordinates:"
        coordinatesDescriptionLabel.text = "\(coordinates.latitude), \(coordinates.longitude)"
    }
}
