import MapKit

class PassAnnotation: NSObject, MKAnnotation {
    private let pass: Pass
    
    var coordinate: CLLocationCoordinate2D {
        return pass.coordinates
    }
    var title: String? {
        return pass.name
    }
    var subtitle: String? {
        return pass.elevation?.description
    }
    var color: UIColor? {
        switch pass.address.region {
        case .abruzzo:
            return .blue
        case .emiliaRomagna:
            return .green
        case .trentinoAltoAdige:
            return .purple
        default:
            return nil
        }
    }
    
    init(pass: Pass) {
        self.pass = pass
        super.init()
    }
}


class PassMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let pass = newValue as? PassAnnotation else { return }
            
            markerTintColor = pass.color
        }
    }
}

