import UIKit

class PassTableDataSource: NSObject {
    private let passes: [Pass]
    private let orderedRegions: [Region]
    
    init(passes: [Pass]) {
        self.passes = passes
        self.orderedRegions = Region.allCases.sorted { $0.rawValue < $1.rawValue }
        super.init()
    }
    
    private func getPasses(for region: Region) -> [Pass] {
        return passes.filter { $0.address.region == region }
    }
    
}

extension PassTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderedRegions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orderedRegions[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let passesForSection = getPasses(for: orderedRegions[section])
        return passesForSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passesForSection = getPasses(for: orderedRegions[indexPath.section])
        let cell = tableView.dequeueReusableCell(withIdentifier: PassCell.defaultIdentifier, for: indexPath) as! PassCell
        return cell.set(withPass: passesForSection[indexPath.row])
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let firstCharacterOfRegions = orderedRegions.map { $0.rawValue.first! }
        return firstCharacterOfRegions.map(String.init)
    }
}
