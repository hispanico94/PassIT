import UIKit

class MapCell: UITableViewCell {
    static let defaultIdentifier = "MapCellIdentifier"
    
    static func getCell() -> MapCell {
        return UINib(nibName: "MapCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! MapCell
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
