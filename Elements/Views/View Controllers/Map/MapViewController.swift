import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let viewModel: MapViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
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
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.annotations
            .bind(to: mapView.rx.annotations)
            .disposed(by: disposeBag)
        
        viewModel.initialMapRegion
            .bind(to: mapView.rx.region)
            .disposed(by: disposeBag)
    }
}
