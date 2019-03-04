import MapKit
import RxCocoa
import RxSwift

// MARK: - MKMapViewDelegate reactive proxy

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    public weak private(set) var mapView: MKMapView?
    
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

// MARK: - MKMapView reactive extensions

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
    
    // Delegate methods
    
    public var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    func annotationCalloutTapped<T: MKAnnotation>(_ annotationType: T.Type) -> Observable<T> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:)))
            .map { parameters in
                return parameters[1] as! MKAnnotationView
            }
            .map { view in
                return view.annotation as! T
        }
    }
}
