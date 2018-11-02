import UIKit

class DataCell: UITableViewCell {
    static let defaultIdentifier = "DataCellIdentifier"

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    private var dataRow: DataRow! {
        didSet {
            keyLabel.text = dataRow.key
            valueLabel.text = dataRow.value
        }
    }
    
    static func getCell() -> DataCell {
        return UINib(nibName: "DataCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DataCell
    }
    
    func set(with dataRow: DataRow) -> DataCell {
        self.dataRow = dataRow
        return self
    }
}
