import UIKit
import RxSwift
import CoreLocation

class PassDetailsDataSource: NSObject {
    private let passData: [Section]
    
    init(pass: Pass, userLocation: Observable<CLLocation?>) {
        self.passData = pass.getDataForDisplayInTableView(userLocation: userLocation)
        super.init()
    }
}

extension PassDetailsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return passData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return passData[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passData[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return passData[indexPath.section].rows[indexPath.row].makeTableViewCell(for: tableView)
    }
}

