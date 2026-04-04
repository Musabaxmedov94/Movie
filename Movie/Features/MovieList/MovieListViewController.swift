//
//  MovieListController.swift
//  Movie
//
//  Created by musabaxmedov on 23.02.26.
//

import UIKit

enum MovieListViewState {
    case loading
    case loaded
    case error(String)
    case reloadData
    case pagingData([IndexPath])
    case addToWatchList(String)
}

protocol MovieListItemModel {
    var id: Int? { get }
    var imageUrlString: String { get }
}

protocol MovieListViewModel: AnyObject {
    var callBack: ((MovieListViewState) -> Void)? { get set}
    var list: [MovieListItemModel] { get }
    func getList()
    func getMoreItem()
    func didSelect(index: Int)
}


final class MovieListViewController: UIViewController {
    
    private let viewModel: MovieListViewModel
    private var isLoading = false
    private var hasMoreData = true
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func didPullToRefresh() {
        isLoading = false
        hasMoreData = true
        viewModel.getList()
    }
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection              = .vertical
        layout.estimatedItemSize            = .zero
        let collection                      = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource               = self
        collection.delegate                 = self
        collection.backgroundColor          = .clear
        collection.refreshControl           = refreshController
        collection.alwaysBounceVertical     = true
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collection
    }()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBinding()
        viewModel.getList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collection.collectionViewLayout.invalidateLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .main
        view.addSubviews(collection)
        
        collection
            .top(equalTo: view.topAnchor).0
            .leading(equalTo: view.leadingAnchor).0
            .trailing(equalTo: view.trailingAnchor).0
            .bottom(equalTo: view.bottomAnchor)
        
    }
    
    private func configureBinding() {
        viewModel.callBack = { [weak self ] state in
            guard let self else { return }
            DispatchQueue.main.async {
                self.render(state: state)
            }
        }
    }
    
    private func render(state: MovieListViewState) {
        switch state {
        case .loading:
            view.showLoading()
        case .loaded:
            view.hideLoading()
            refreshController.endRefreshing()
        case .error(let message):
            isLoading = false
            show(title: "Error", message: message  )
        case .reloadData:
            hasMoreData = true
            collection.reloadData()
        case .pagingData(let indexPaths):
            isLoading = false
            if indexPaths.isEmpty { hasMoreData = false }
            
            let count = collection.numberOfItems(inSection: 0)
            let safeIndexPath = indexPaths.filter{ $0.item >= 0 && $0.item <= viewModel.list.count }
            
            guard !safeIndexPath.isEmpty else {
                collection.reloadData()
                return
            }
            
            if safeIndexPath.first?.item == count {
                collection.performBatchUpdates {
                    collection.insertItems(at: safeIndexPath)
                }
            } else {
                collection.reloadData()
            }
        case .addToWatchList(let message):
            show(title: message, message: nil)
        }
    }
    
    private func loadMore() {
        isLoading = true
        viewModel.getMoreItem()
    }
    
    func cellWidth(width: CGFloat) -> CGFloat{
        (width - 72) / 3
    }
    
    func callHeight(cellWidth: CGFloat) -> CGFloat {
        cellWidth * 1.46
    }
    
    
}


extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let cell = cell as? ImageCell {
            let cellData = viewModel.list[indexPath.item]
            cell.configure(urlString: cellData.imageUrlString, cornerRadius: 16)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth                       = cellWidth(width: collectionView.frame.width)
        let cellHeight                      = callHeight(cellWidth: cellWidth)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    // MARK: - Trigger by Scroll (scrollViewDidScroll)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading, hasMoreData else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        let threeshold: CGFloat = 150
        
        if offsetY > (contentHeight - frameHeight - threeshold) {
            loadMore()
        }
    }
    
    // MARK: - Trigger by Cell (willDisplay)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !isLoading, hasMoreData else { return }
        if indexPath.item == viewModel.list.count - 6 {
            loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.list.count else { return }
        viewModel.didSelect(index: indexPath.item)
        
    }
    
}
 
