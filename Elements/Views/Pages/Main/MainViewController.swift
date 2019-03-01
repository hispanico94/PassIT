import UIKit

class MainViewController: UIViewController {

    private let segmentedControl = UISegmentedControl(frame: CGRect.zero)
    private let mapViewController: MapViewController
    private let passTableViewController: PassTableViewController
    
    
    init(mapViewController: MapViewController, passTableViewController: PassTableViewController) {
        self.mapViewController = mapViewController
        self.passTableViewController = passTableViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Map", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "List", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MainViewController.selectionDidChange(_:)), for: .valueChanged)
        
        navigationItem.titleView = segmentedControl
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: passTableViewController)
            add(asChildViewController: mapViewController)
        } else {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: passTableViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
    
    @objc private func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

}
