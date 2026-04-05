//
//  UIColor+Assets.swift
//  Movie
//
//  Created by musabaxmedov on 12.03.26.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        self.init(
            red:   CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue:  CGFloat(rgb & 0xFF) / 255,
            alpha: 1.0
        )
    }
    
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

