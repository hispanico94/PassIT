import UIKit

class PassTableViewController: UITableViewController {
    
    let dataSource: PassTableDataSource
    let delegate: PassTableDelegate
    
    let passes: [Pass]
    
    init(passes: [Pass]) {
        self.passes = passes
        self.dataSource = PassTableDataSource(passes: passes)
        self.delegate = PassTableDelegate()
        
        super.init(nibName: nil, bundle: nil)
        
        self.delegate.cellSelectionHandler = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        tableView.register(UINib(nibName: "PassCell", bundle: nil), forCellReuseIdentifier: PassCell.defaultIdentifier)
    }
}
