import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class PassTableViewController: UITableViewController {
    let viewModel: PassTableViewModel
    
    var dataSource: RxTableViewSectionedReloadDataSource<PassTableSection>!
    
    let disposeBag = DisposeBag()
    
    init(viewModel: PassTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: "PassCell", bundle: nil), forCellReuseIdentifier: PassCell.defaultIdentifier)
        
        configureDataSource()
        bindUI()
    }
    
    private func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<PassTableSection>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: PassCell.defaultIdentifier, for: indexPath) as! PassCell
                return cell.set(withPass: item)
        },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header.rawValue
        },
            sectionIndexTitles: { dataSource in
                return dataSource.sectionModels.map { $0.header.abbreviated }
        })
    }
    
    private func bindUI() {
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Pass.self)
            .subscribe(onNext: { [weak self] pass in
                self?.viewModel.passSelected(pass)
            })
            .disposed(by: disposeBag)
    }
}


// UITableViewDelegate methods
extension PassTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
}
