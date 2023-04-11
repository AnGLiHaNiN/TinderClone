//
//  SwipingPhotosController.swift
//  TinderClone
//
//  Created by Михаил on 04.03.2023.
//

import UIKit

class SwipingPhotosController: UIPageViewController {
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                return PhotoController(imageUrl: imageUrl)
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: true)
            
            setupBarViews()
        }
    }
    
    fileprivate var barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate var isCardViewMode = false
    
    
    init(isCardViewMode: Bool = false) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.isCardViewMode = isCardViewMode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBarViews(){
        
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 4
        view.addSubview(barsStackView)
        barsStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    var controllers = [UIViewController]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        view.backgroundColor = .systemBackground
        
        if isCardViewMode {
            disableSwipingAbilyty()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        let currentController = viewControllers!.first!
        barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedBarColor }
        
        if let index = controllers.firstIndex(of: currentController){
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1,  controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: true)
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let prewIndex = max(index - 1, 0)
                let prewController = controllers[prewIndex]
                setViewControllers([prewController], direction: .reverse, animated: true)
                barsStackView.arrangedSubviews[prewIndex].backgroundColor = .white
            }
        }
    }
    
    fileprivate func disableSwipingAbilyty(){
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
}


extension SwipingPhotosController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil}
        return controllers[index + 1]
    }
}

extension SwipingPhotosController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}){
            barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedBarColor }
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}
