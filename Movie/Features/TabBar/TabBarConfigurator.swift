//
//  TabBarConfigurator.swift
//  Movie
//
//  Created by musabaxmedov on 11.03.26.
//

import UIKit


final class TabBarConfigurator {
    
    // MARK: - Tab Setup
    func configureTabs(
        for tabBar: UITabBarController
    ) {
        tabBar.viewControllers = [
            makeNav(root: HomeViewController(), title: "Home", image: .home, selectedImage: .home),
            makeNav(root: SearchViewController(), title: "Search", image: .search, selectedImage: .search),
            makeNav(root: MovieListViewController(viewModel: WatchListViewModel()), title: "Watch list", image: .watchList, selectedImage: .watchList)
        ]
    }
    
    //MARK: - Appearance
    func configureAppearance(for tabBarController: UITabBarController) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
       
        applyItemAppearance(to: appearance.stackedLayoutAppearance)
        applyItemAppearance(to: appearance.inlineLayoutAppearance)
        applyItemAppearance(to: appearance.compactInlineLayoutAppearance)
        
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.tintColor = .selected
        tabBarController.tabBar.unselectedItemTintColor = .unselected
        
    }
    
    // MARK: - Private Helpers
    private func makeNav(
        root: UIViewController,
        title: String,
        image: UIImage,
        selectedImage: UIImage) -> UINavigationController {
            
        root.tabBarItem = UITabBarItem(
            title: title,
            image: image.template,
            selectedImage: selectedImage.template)
            
        return UINavigationController(rootViewController: root)
    }
    
    private func applyItemAppearance(to itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .unselected
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.unselected]
        
        itemAppearance.selected.iconColor = .selected
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.selected]
       
    }
    
}
