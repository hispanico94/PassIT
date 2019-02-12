import MapKit
import RxCocoa
import RxSwift

extension Reactive where Base: MKMapView {
    var region: Binder<MKCoordinateRegion> {
        return Binder(self.base) { mapView, region in
            mapView.setRegion(region, animated: true)
        }
    }
}
