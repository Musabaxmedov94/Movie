//
//  Untitled.swift
//  BankApp
//
//  Created by musabaxmedov on 07.12.25.
//

import UIKit

extension UIView {
    
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    @discardableResult
    func top( equalTo: NSLayoutYAxisAnchor,
              constant: CGFloat = 0,
              _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func bottom( equalTo: NSLayoutYAxisAnchor,
                 constant: CGFloat = 0,
                 _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint){
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func centerY( equalTo: NSLayoutYAxisAnchor,
                  constant: CGFloat = 0,
                  _ isActive: Bool = true ) ->(UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func leading( equalTo:  NSLayoutXAxisAnchor,
                  constant: CGFloat = 0,
                  _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func trailing( equalTo: NSLayoutXAxisAnchor,
                   constant: CGFloat = 0,
                   _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func centerX( equalTo:  NSLayoutXAxisAnchor,
                  constant: CGFloat = 0,
                  _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: equalTo, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func width( constant: CGFloat = 0,
                _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func height( constant: CGFloat = 0,
                 _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func width( equalTo: NSLayoutDimension,
                multiplier: CGFloat = 0,
                _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: equalTo, multiplier: multiplier)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func height( equalTo: NSLayoutDimension,
                 multiplier: CGFloat = 0,
                 _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: equalTo, multiplier: multiplier)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    @discardableResult
    func width( equalTo: NSLayoutDimension,
                multiplier: CGFloat = 0,
                constant: CGFloat = 0,
                _ isActive: Bool = true ) -> (UIView, NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
        constraint.isActive = isActive
        return (self, constraint)
    }
    
    
}

