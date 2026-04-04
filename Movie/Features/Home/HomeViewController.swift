//
//  HomeController.swift
//  Movie
//
//  Created by musabaxmedov on 01.02.26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    var currentPage: Int?
    
    private lazy var segmentView: BottomBarSegmentView = {
        let segmentView = BottomBarSegmentView(segments: [
            "Now playing", "Upcoming", "Top rated", "Popular"
        ])
        segmentView.callback = {
            [weak self] index in
            guard let self else { return }
            self.tapSegment(index: index)
        }
        return segmentView
    }()
    
    private lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        return pageController
    }()
    
    private lazy var controllers: [UIViewController] = [
        MovieListViewController(viewModel: NowPlayingViewModel()),
        MovieListViewController(viewModel: UpcomingViewModel()),
        MovieListViewController(viewModel: TopRatedViewModel()),
        MovieListViewController(viewModel: PopularViewModel())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    private func configureView() {
        view.backgroundColor = .main
        addChild(pageController)
        view.addSubviews(segmentView, pageController.view)
        
        segmentView
            .top(equalTo: view.safeAreaLayoutGuide.topAnchor).0
            .leading(equalTo: view.leadingAnchor, constant: 24).0
            .trailing(equalTo: view.trailingAnchor, constant: -24)
        
        
        pageController.view
            .top(equalTo: segmentView.bottomAnchor).0
            .leading(equalTo: view.leadingAnchor).0
            .trailing(equalTo: view.trailingAnchor).0
            .bottom(equalTo: view.bottomAnchor)
        
        
        tapSegment(index: 0)
    }
    
    
    
    private func tapSegment(index: Int) {
        guard controllers.indices.contains(index), index != currentPage else { return }

        let direction: UIPageViewController.NavigationDirection =
            index > (currentPage ?? 0) ? .forward : .reverse

        pageController.setViewControllers([controllers[index]], direction: direction, animated: true) {
            [weak self] finished in
            guard let self, finished else { return }
            self.currentPage = index
        }
    }
}

/*extension HomeViewController: UIPageViewControllerDataSource {
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
 <#code#>
 }
 
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
 <#code#>
 }
 
 
 }*/
