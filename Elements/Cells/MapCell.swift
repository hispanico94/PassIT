import UIKit
import MapKit

class MapCell: UITableViewCell {
    static let defaultIdentifier = "MapCellIdentifier"
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.isScrollEnabled = false
            //mapView.isZoomEnabled = false
            mapView.isPitchEnabled = false
            mapView.isRotateEnabled = false
            mapView.showsUserLocation = true
        }
    }
    
    private let regionRadius: CLLocationDistance = 10000
    
    private var coordinates: CLLocationCoordinate2D! {
        didSet {
            setMap()
        }
    }
    
    static func getCell() -> MapCell {
        return UINib(nibName: "MapCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MapCell
    }
    
    func set(with coordinates: CLLocationCoordinate2D) -> MapCell {
        self.coordinates = coordinates
        return self
    }
    
    private func setMap() {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}
