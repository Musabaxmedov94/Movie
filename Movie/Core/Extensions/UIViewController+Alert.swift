//
//  File.swift
//  Movie
//
//  Created by musabaxmedov on 12.03.26.
//


import UIKit

extension UIViewController {
    func show(title: String?, message: String?, callBack: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            _ in
            callBack?()
        }))
        present(alert, animated: true)
    }
}

