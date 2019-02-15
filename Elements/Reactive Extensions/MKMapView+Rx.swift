import MapKit
import RxCocoa
import RxSwift

extension Reactive where Base: MKMapView {
    var region: Binder<MKCoordinateRegion> {
        return Binder(self.base) { mapView, region in
            mapView.setRegion(region, animated: true)
        }
    }
    
    var annotations: Binder<[MKAnnotation]> {
        return Binder(self.base) { mapView, annotations in
            mapView.addAnnotations(annotations)
        }
    }
}
