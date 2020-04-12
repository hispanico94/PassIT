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
    
    override func prepareForReuse() {
        pass = nil
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
    }
    
    private func setTextLabel() {
        self.textLabel?.text = pass?.name
    }
    
    private func setDetailTextLabel() {
        if let elevation = pass?.elevation {
            self.detailTextLabel?.text = "\(elevation.integerDescription)"
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
            self.imageView?.tintColor = .iconColor
        }
    }
}

private extension UIColor {
  static var iconColor: UIColor {
    if #available(iOS 13, *) {
      return .secondaryLabel
    } else {
      return .black
    }
  }
}
