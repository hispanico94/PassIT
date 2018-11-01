import UIKit

class DataCell: UITableViewCell {
    static let defaultIdentifier = "DataCellIdentifier"

    
    static func getCell() -> DataCell {
        return UINib(nibName: "DataCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DataCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
