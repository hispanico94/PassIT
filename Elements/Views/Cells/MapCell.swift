import UIKit
import MapKit

class MapCell: UITableViewCell {
    static let defaultIdentifier = "MapCellIdentifier"
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
            mapView.isPitchEnabled = false
            mapView.isRotateEnabled = false
            mapView.showsUserLocation = true
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(userDidPinch(_:)))
            mapView.addGestureRecognizer(pinchRecognizer)
            
            mapView.register(PassMarkerViewMapCell.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
    }
    
    private let initialRegionRadius: CLLocationDistance = 10000
    private var regionDisplayed: MKCoordinateRegion!
    
    private var pass: Pass! {
        didSet {
            setMap()
        }
    }
    
    static func getCell() -> MapCell {
        return UINib(nibName: "MapCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MapCell
    }
    
    func set(with pass: Pass) -> MapCell {
        self.selectionStyle = .none
        self.pass = pass
        return self
    }
    
    private func setMap() {
        regionDisplayed = MKCoordinateRegion(center: pass.coordinates, latitudinalMeters: initialRegionRadius, longitudinalMeters: initialRegionRadius)
        mapView.setRegion(regionDisplayed, animated: true)
        
        let annotation = PassAnnotation(pass: pass)
        mapView.addAnnotation(annotation)
    }
    
    @objc func userDidPinch(_ sender: UIGestureRecognizer) {
        guard let sender = sender as? UIPinchGestureRecognizer else { return }
        
        let latitudeDelta = regionDisplayed.span.latitudeDelta / CLLocationDegrees(sender.scale)
        let longitudeDelta = regionDisplayed.span.longitudeDelta / CLLocationDegrees(sender.scale)
        
        let newSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let newRegion = MKCoordinateRegion(center: pass.coordinates, span: newSpan)
        
        mapView.setRegion(newRegion, animated: false)
        
        if sender.state == .ended {
            regionDisplayed = self.mapView.region
        }
    }
}
