import UIKit
import RxSwift
import CoreLocation

class PassDetailsViewController: UITableViewController {
    
    private let tableViewDataSource: PassDetailsDataSource
    
    init(pass: Pass, userLocation: Observable<CLLocation?>) {
        self.tableViewDataSource = PassDetailsDataSource(pass: pass, userLocation: userLocation)
        super.init(nibName: nil, bundle: nil)
        
        self.title = pass.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = CGFloat(200)
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = tableViewDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
