import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let items: Observable<[Pass]>
    private let initialMapRegion: Observable<MKCoordinateRegion>
    private let passSelected: AnyObserver<Pass>
    
    private let disposeBag = DisposeBag()
    
    init(items: Observable<[Pass]>, initialMapRegion: Observable<MKCoordinateRegion>, passSelected: AnyObserver<Pass>) {
        self.items = items
        self.initialMapRegion = initialMapRegion
        self.passSelected = passSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(PassMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.showsUserLocation = true
        
        bindUI()
    }
    
    private func bindUI() {
        items
            .map { $0.map(PassAnnotation.init) }
            .bind(to: mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        initialMapRegion
            .bind(to: mapView.rx.region)
            .disposed(by: disposeBag)
        
        mapView.rx.annotationCalloutTapped(PassAnnotation.self)
            .map { $0.pass }
            .bind(to: passSelected)
            .disposed(by: disposeBag)
    }
}
