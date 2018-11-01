import UIKit

class PassCell: UITableViewCell {
    static let defaultIdentifier = "PassCellIdentifier"
    private(set) var pass: Pass? {
        didSet {
            setTextLabel()
            setDetailTextLabel()
            setImage()
        }
    }
    
    func set(withPass pass: Pass) -> PassCell {
        self.pass = pass
        return self
    }
    
    private func setTextLabel() {
        self.textLabel?.text = pass?.name
    }
    
    private func setDetailTextLabel() {
        if let elevation = pass?.elevation {
            self.detailTextLabel?.text = "\(elevation.integerDescription) - \(pass!.address.region.rawValue)"
        } else {
            self.detailTextLabel?.text = pass?.address.region.rawValue
        }
    }
    
    private func setImage() {
        if let type = pass?.type {
            switch type {
            case .pass:
                self.imageView?.image = UIImage(named: "pass_icon")
            case .peak:
                self.imageView?.image = UIImage(named: "peak_icon")
            }
        }
    }
}
