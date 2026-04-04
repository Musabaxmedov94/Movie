//
//  TabBar.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let configurator = TabBarConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureTabs(for: self)
        configurator.configureAppearance(for: self)
    }
    
   
}

