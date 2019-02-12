import MapKit

extension MKDirections.Request {
    static func drivingDirections(from source: MKPlacemark, to destination: MKPlacemark) -> MKDirections.Request {
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: source)
        directionRequest.destination = MKMapItem(placemark: destination)
        directionRequest.transportType = .automobile
        
        return directionRequest
    }
}
