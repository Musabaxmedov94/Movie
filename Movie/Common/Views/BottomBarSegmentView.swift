//
//  BottomBarSegmentView.swift
//  Movie
//
//  Created by musabaxmedov on 21.02.26.
//

import UIKit

final class BottomBarSegmentView: UIView {
    
    var callback: ((Int) -> Void)?
    
    private let segments: [String]
    
    private var bottomBarViewLeading: NSLayoutConstraint?
    
    private lazy var stack: UIStackView = {
        let stack  = UIStackView()
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var bottomBarView: UIView = {
        let bottomBarView = UIView()
        bottomBarView.backgroundColor = .bottomBarView
        return bottomBarView
    }()
    
    init(segments: [String]) {
        self.segments = segments
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubviews(stack, bottomBarView)
        let segmentCount = CGFloat(segments.count)
        
        stack
            .top(equalTo: topAnchor).0
            .leading(equalTo: leadingAnchor).0
            .bottom(equalTo: bottomAnchor, constant: -8).0
            .trailing(equalTo: trailingAnchor)
        
        bottomBarViewLeading = bottomBarView
            .bottom(equalTo: bottomAnchor).0
            .height(constant: 4).0
            .width(equalTo: widthAnchor, multiplier: 1 / segmentCount, constant: -12 * (segmentCount - 1)/segmentCount ).0
            .leading(equalTo: leadingAnchor).1
        
        
        /*
         for segmentIndex in segments.indices {
            stack.addArrangedSubview(label(text: segments[segmentIndex], index: segmentIndex))
        }
         */
        
        segments.enumerated().forEach { index, text in
            stack.addArrangedSubview(label(index: index, text: text))
        }
    }
    
    private func label(index: Int, text: String) -> UILabel {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth  = true
        label.textColor                  = .white
        label.font                       = .systemFont(ofSize: 14,weight: .medium)
        label.textAlignment              = .center
        label.isUserInteractionEnabled   = true
        label.tag                        = index
        label.text                       = text
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSegment))
        label.addGestureRecognizer(tap)
        return label
    }
    
    @objc private func tapSegment(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view,
              stack.arrangedSubviews.indices.contains(gestureView.tag) else { return }
        let leadingConstant = stack.arrangedSubviews[gestureView.tag].frame.minX
        updateLeading(constant: leadingConstant)
        callback?(gestureView.tag)
    }
    
    private func updateLeading(constant: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            guard let self else { return }
            self.bottomBarViewLeading?.constant = constant
            self.layoutIfNeeded()
        }
        
    }
}
