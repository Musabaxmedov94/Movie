//
//  ImageCell.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//

import UIKit
import Bricks

final class ImageCell: UICollectionViewCell {
    
    private var currentURLString: String?
    private static let decodeQueue = DispatchQueue(label: "com.movie.image.decode", qos: .userInitiated)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
   /*
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    */
    
    private lazy var shimmerView: ShimmerView = {
        let view = ShimmerView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentURLString  = nil
        imageView.image   = nil
        shimmerView.stop()
        shimmerView.isHidden = true
        //activityIndicator.stopAnimating()
    }
    
    
    private func configureView() {
        contentView.addSubviews(imageView, /*activityIndicator*/ shimmerView)
        
        imageView
            .top(equalTo: contentView.topAnchor).0
            .leading(equalTo: contentView.leadingAnchor).0
            .trailing(equalTo: contentView.trailingAnchor).0
            .bottom(equalTo: contentView.bottomAnchor)
        
        shimmerView
            .top(equalTo: contentView.topAnchor).0
            .leading(equalTo: contentView.leadingAnchor).0
            .trailing(equalTo: contentView.trailingAnchor).0
            .bottom(equalTo: contentView.bottomAnchor)
        
        /*activityIndicator.centerX(equalTo: contentView.centerXAnchor)
        activityIndicator.centerY(equalTo: contentView.centerYAnchor)*/
    }
    
    func configure(urlString: String, cornerRadius: CGFloat) {
        currentURLString = urlString
        imageView.image  = nil
        imageView.layer.cornerRadius = cornerRadius
        shimmerView.layer.cornerRadius = cornerRadius
        
        shimmerView.isHidden = false
        shimmerView.start()
        //activityIndicator.startAnimating()
        
        ImageLoader.shared.fetchCacheImage(urlString: urlString) { [weak self] data in
            guard let self else { return }
            guard self.currentURLString == urlString else { /*self.activityIndicator.stopAnimating()*/ return }
            
            ImageCell.decodeQueue.async { [weak self] in
                let image: UIImage? = autoreleasepool { data.flatMap(UIImage.init(data:)) }
                DispatchQueue.main.async {
                    guard let self else { return }
                    guard self.currentURLString == urlString else { /*self.activityIndicator.stopAnimating()*/ return }
                    
                    
                    defer { /*self.activityIndicator.stopAnimating()*/
                        self.shimmerView.stop()
                        self.shimmerView.isHidden = true
                    }
                    
                    /*
                    guard let data = data, let image = UIImage(data: data) else {
                        self.imageView.image = nil
                        return
                    }
                    */
                    
                    UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve) {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    
}
