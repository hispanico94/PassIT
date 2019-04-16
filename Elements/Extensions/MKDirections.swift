import MapKit

extension MKDirections.Request {
    static func drivingDirections(from source: MKPlacemark, to destination: MKPlacemark) -> MKDirections.Request {
        let directionRequest = MKDirections.Request()
            |> (prop(\MKDirections.Request.source)) { _ in MKMapItem(placemark: source) }
            <> (prop(\MKDirections.Request.destination)) { _ in MKMapItem(placemark: destination)}
            <> (prop(\MKDirections.Request.transportType)) { _ in .automobile }
        
        return directionRequest
    }
}
