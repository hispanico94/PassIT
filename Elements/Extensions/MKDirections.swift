import MapKit

extension MKDirections.Request {
    static func drivingDirections(from source: MKPlacemark, to destination: MKPlacemark) -> MKDirections.Request {
        let directionRequest = MKDirections.Request()
            |> set(^\MKDirections.Request.source, MKMapItem(placemark: source))
            <> set(^\MKDirections.Request.destination, MKMapItem(placemark: destination))
            <> set(^\MKDirections.Request.transportType, .automobile)
        
        return directionRequest
    }
}
