//
//  PassCell.swift
//  PassIT
//
//  Created by Paolo Rocca on 29/10/2018.
//  Copyright © 2018 Paolo Rocca. All rights reserved.
//

import UIKit

class PassCell: UITableViewCell {
    static let defaultIdentifier = "PassCellIdentifier"
    private(set) var pass: Pass?
    
    func set(withPass pass: Pass) -> PassCell {
        self.pass = pass
        
        self.textLabel?.text = pass.name
        
        if let elevation = pass.elevation {
            self.detailTextLabel?.text = "\(elevation.integerDescription) - \(pass.address.region.rawValue)"
        } else {
            self.detailTextLabel?.text = "\(pass.address.region.rawValue)"
        }
        
        if let type = pass.type {
            switch type {
            case .pass:
                self.imageView?.image = UIImage(named: "pass_icon")
            case .peak:
                self.imageView?.image = UIImage(named: "peak_icon")
            }
        }
        
        return self
    }
}
