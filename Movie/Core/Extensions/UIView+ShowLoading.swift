//
//  UIView+LoadingVIew.swift
//  Movie
//
//  Created by musabaxmedov on 14.03.26.
//

import UIKit

extension UIView {
    
    func showLoading(size: CGSize = CGSizeMake(100, 100), backgroundColor: UIColor = .main) {
        
        if let loadingView = subviews.first(where: {$0 is LoadingView}) as? LoadingView {
            bringSubviewToFront(loadingView)
            loadingView.start()
        } else {
            let loadingView = LoadingView(size: size)
            loadingView.backgroundColor = backgroundColor
            addSubview(loadingView)
            loadingView
                .top(equalTo: safeAreaLayoutGuide.topAnchor).0
                .leading(equalTo: safeAreaLayoutGuide.leadingAnchor).0
                .bottom(equalTo: safeAreaLayoutGuide.bottomAnchor).0
                .trailing(equalTo: safeAreaLayoutGuide.trailingAnchor)
            loadingView.start()
            loadingView.isHidden = false
        }
    }
    
    func hideLoading() {
        if let loadingView = subviews.first(where: {$0 is LoadingView}) as? LoadingView {
            loadingView.stop()
            loadingView.isHidden = true
        }
    }
    
}
