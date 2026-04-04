//
//  UIImage+Assets.swift
//  Movie
//
//  Created by musabaxmedov on 12.03.26.
//

import UIKit

extension UIImage {
    
    private static func asset(_ name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            assertionFailure("Missing color asset: \(name)")
            return UIImage()
        }
        return image
    }
    
    static var home: UIImage { asset("homeIcon") }
    static var search: UIImage { asset("searchIcon") }
    static var watchList: UIImage { asset("watchListIcon") }
    
    var template: UIImage { withRenderingMode(.alwaysTemplate) }
}
