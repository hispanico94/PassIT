import UIKit

class PassTableViewController: UITableViewController {
    
    let tableViewDataSource: PassTableDataSource
    let tableViewDelegate: PassTableDelegate
    
    init(dataSource: PassTableDataSource, delegate: PassTableDelegate) {
        self.tableViewDataSource = dataSource
        self.tableViewDelegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.tableViewDelegate.cellSelectionHandler = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        
        tableView.register(UINib(nibName: "PassCell", bundle: nil), forCellReuseIdentifier: PassCell.defaultIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
