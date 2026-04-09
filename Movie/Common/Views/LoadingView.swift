//
//  LoadingVIew.swift
//  Movie
//
//  Created by musabaxmedov on 13.03.26.
//

import UIKit
import Bricks

final class LoadingView: UIView {
    
    private let animation: UIActivityIndicatorView = {
        let animation = UIActivityIndicatorView(style: .large)
        return animation
    }()
    
    init(size: CGSize){
        super .init(frame: .zero)
        configureView(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(size: CGSize) {
        addSubviews(animation)
        
        animation
            .centerX(equalTo: centerXAnchor).0
            .centerY(equalTo: centerYAnchor).0
            .width(constant: size.width).0
            .height(constant: size.height)
    }
    
    func start() {
        if !animation.isAnimating {
            animation.startAnimating()
        }
    }
    
    func stop() {
        animation.stopAnimating()
    }
}
