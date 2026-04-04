//
//  ShimmerView.swift
//  Movie
//
//  Created by musabaxmedov on 14.03.26.
//

import UIKit

final class ShimmerView: UIView {
    
    override class var layerClass: AnyClass {CAGradientLayer.self}
    private var gradientLayer:  CAGradientLayer { layer as! CAGradientLayer }

    private var shouldAnimate = false
    
    private let base = UIColor(red: 0x3A/255, green: 0x41/255, blue: 0x4B/255, alpha: 1).cgColor
    private let highlight = UIColor(red: 0x4F/255, green: 0x59/255, blue: 0x68/255, alpha: 1).cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        isUserInteractionEnabled = false
        clipsToBounds = true
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        
        gradientLayer.backgroundColor = highlight
        gradientLayer.locations = [0, 0.47, 0.5, 0.53, 1]
        gradientLayer.colors = [base, base, highlight, base, base]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldAnimate && gradientLayer.animation(forKey: "shimmer") == nil { addShimmerAnimation()}
    }
    
    private func addShimmerAnimation() {
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue      = [-1, -0.55, -0.5, -0.45, 0]
        anim.toValue        = [1, 1.45, 1.5, 1.55, 2]
        anim.duration       = 1
        anim.repeatCount    = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(anim, forKey: "shimmer")
    }
    
    func start() {
        shouldAnimate = true
        guard gradientLayer.animation(forKey: "shimmer") == nil else { return }
        addShimmerAnimation()
    }
    
    func stop() {
        shouldAnimate = false
        gradientLayer.removeAnimation(forKey: "shimmer")
    }
}
