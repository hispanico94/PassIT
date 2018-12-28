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
        return pass.elevation?.integerDescription
    }
    var color: UIColor? {
        switch pass.address.region {
        case .friuliVeneziaGiulia:
            return nil
        case .veneto:
            return .blue
        case .trentinoAltoAdige:
            return .purple
        case .lombardia:
            return nil
        case .valleAosta:
            return .brown
        case .piemonte:
            return .blue
        case .liguria:
            return .purple
        case .emiliaRomagna:
            return .brown
        case .toscana:
            return .blue
        case .marche:
            return .purple
        case .umbria:
            return nil
        case .lazio:
            return .brown
        case .abruzzo:
            return .blue
        case .molise:
            return .purple
        case .campania:
            return nil
        case .basilicata:
            return .blue
        case .calabria:
            return .brown
        default:
            return nil
        }
    }
    var icon: String? {
        guard let type = pass.type else { return nil }
        switch type {
        case .pass:
            return "pass_icon"
        case .peak:
            return "peak_icon"
        }
    }
    var address: String {
        return "\(pass.address.road), \(pass.address.municipality) (\(pass.address.province))"
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
            
            if let views = Bundle.main.loadNibNamed("DetailAccessoryView", owner: self, options: nil) as? [DetailAccessoryView], views.count > 0 {
                let detailAccessoryView = views.first!
                detailAccessoryView.configure(elevation: pass.subtitle, address: pass.address, coordinates: pass.coordinate)
                detailCalloutAccessoryView = detailAccessoryView
            }
            
            if let icon = pass.icon {
                glyphImage = UIImage(named: icon)
            }
        }
    }
}


//TODO: change name of this class
class PassMarkerViewMapCell: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let pass = newValue as? PassAnnotation else { return }
            
            markerTintColor = pass.color
            
            if let icon = pass.icon {
                glyphImage = UIImage(named: icon)
            }
            
            isEnabled = false
        }
    }
}
