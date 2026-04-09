//
//  SearchController.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//

import UIKit
import FlexLayout

final class SearchViewController: UIViewController {
    
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "3A3F47")
        view.layer.borderColor = UIColor(hex: "67686D").cgColor
        view.layer.borderWidth  = 0.5
        view.layer.cornerRadius = 21
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [ .foregroundColor : UIColor(hex: "67686D")]
        )
        textField.textColor = UIColor(hex: "FFFFFF")
        return textField
    }()
    
    private lazy var searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(hex: "67686D")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    private func configureView() {
        view.backgroundColor = .main
        view.addSubview(searchContainerView)
        searchContainerView.addSubviews(searchTextField, searchIcon)
        
        searchContainerView
            .top(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).0
            .leading(equalTo: view.leadingAnchor, constant: 29).0
            .trailing(equalTo: view.trailingAnchor, constant: -29).0
            .height(constant: 42)
        
        searchIcon
            .trailing(equalTo: searchContainerView.trailingAnchor, constant: -12).0
            .centerY(equalTo: searchContainerView.centerYAnchor).0
            .width(constant: 20).0
            .height(constant: 20)
        
        searchTextField
            .leading(equalTo: searchContainerView.leadingAnchor, constant: 12).0
            .trailing(equalTo: searchIcon.leadingAnchor, constant: -8).0
            .centerY(equalTo: searchContainerView.centerYAnchor)
        
    }
    
    
    
}

