//
//  UIColor+Assets.swift
//  Movie
//
//  Created by musabaxmedov on 12.03.26.
//

import UIKit

extension UIColor {
    
    private static func asset(_ name: String, fallBack: UIColor) -> UIColor{
        guard let color = UIColor(named: name) else {
            assertionFailure("Missing color asset: \(name)")
            return fallBack
        }
        return color
    }
    
    static var main: UIColor { asset("colorSystemBackground", fallBack: .systemBackground) }
    static var selected: UIColor { asset("selectedIconColor", fallBack: .label) }
    static var unselected: UIColor { asset("unselectedIconColor", fallBack: .secondaryLabel) }
}

