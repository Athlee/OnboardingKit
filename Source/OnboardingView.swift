//
//  OnboardingView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit


public final class OnboardingView: UIView, CAAnimationDelegate {
  
  // MARK: Properties 
  
  public let pageControlView = PageControlView()
  
  public weak var dataSource: OnboardingViewDataSource? { didSet { reload() } }
  
  public weak var delegate: OnboardingViewDelegate? {
    didSet {
      for (i, pageView) in pageViews.enumerated() {
        delegate?.onboardingView?(self, configurePageView: pageView, atPage: i)
      }
    }
  }
  
  public var topContainerOffset: CGFloat = 8 { didSet { pageViews.forEach { $0.topContainerOffset = topContainerOffset } } }
  public var bottomPageControlViewOffset: CGFloat = 32 { didSet { bottomPageControlViewAnchor.constant = -bottomPageControlViewOffset } }
  
  fileprivate var bottomPageControlViewAnchor: NSLayoutConstraint!
  
  fileprivate var pageViews: [PageView] = []
  fileprivate var configurations: [Int: OnboardingConfiguration] = [:]
  
  // MARK: Life cycle
  
  public init() {
    super.init(frame: .zero)
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  fileprivate var layouted = false
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    if !layouted {
      layouted = true
      
      for (i, pageView) in pageViews.enumerated() {
        if i > 0 {
          maskPageView(pageView, state: .folded)
        }
      }
    }
  }
  
  // MARK: Setup
  
  fileprivate func setup() {
    // Refresh
    topContainerOffset = 8
    
    // Setup PageControlView
    insertSubview(pageControlView, at: Int.max)
    
    pageControlView.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 9.0, *) {
        bottomPageControlViewAnchor = pageControlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPageControlViewOffset)
    } else {
        bottomPageControlViewAnchor = pageControlView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor, constant: -bottomPageControlViewOffset)
    }
    
    if #available(iOS 9.0, *) {
        let pageControlViewAnchors = [
            pageControlView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pageControlView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -8),
            bottomPageControlViewAnchor,
            pageControlView.heightAnchor.constraint(equalToConstant: PageControlView.radiusExpanded)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(pageControlViewAnchors)
    } else {
        let pageControlViewAnchors = [
            pageControlView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor, constant: 8),
            pageControlView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor, constant:  -8),
            bottomPageControlViewAnchor,
            pageControlView.anchors.heightAnchor.constraintEqualToConstant(PageControlView.radiusExpanded)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(pageControlViewAnchors)
    }
    
    // Add resture recognizers
    addRecognizers()
  }
  
  fileprivate func reload() {
    if let dataSource = dataSource {
      pageControlView.pages = dataSource.numberOfPages()
      
      for i in 0..<dataSource.numberOfPages() {
        let pageView = preparedPageView(at: i)
        pageViews += [pageView]
        
        if let config = configurations[i] {
          pageControlView.items[i].image = config.itemImage
        }
      }
    }
  }
  
  fileprivate func preparedPageView(at page: Int) -> PageView {
    guard let dataSource = dataSource else {
      fatalError("DataSource not found!")
    }
    
    let config = dataSource.onboardingView(self, configurationForPage: page)
    configurations[page] = config
    
    let pageView = PageView()
    
    insertSubview(pageView, belowSubview: pageControlView)
    
    pageView.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 9.0, *) {
        let anchors = [
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(anchors)
    } else {
        let _anchors = [
            pageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            pageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            pageView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor),
            pageView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(_anchors)
    }
    
    pageView.configuration = config
    
    return pageView
  }
  
  fileprivate func addRecognizers() {
    let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(OnboardingView.didRecognizeSwipe(_:)))
    leftSwipeRecognizer.direction = .left
    
    let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(OnboardingView.didRecognizeSwipe(_:)))
    rightSwipeRecognizer.direction = .right
    
    addGestureRecognizer(leftSwipeRecognizer)
    addGestureRecognizer(rightSwipeRecognizer)
  }
  
  internal func didRecognizeSwipe(_ recognizer: UISwipeGestureRecognizer) {
    switch recognizer.direction {
    case UISwipeGestureRecognizerDirection.left:
      guard pageControlView.currentPage + 1 < pageControlView.pages else {
        return
      }
      
      pageControlView.currentPage += 1
      delegate?.onboardingView?(self, willSelectPage: pageControlView.currentPage)
      
      let previous = previousPageView()
      let current = currentPageView()
      
      insertSubview(current, aboveSubview: previous)
      
      maskPageView(current, state: .folded)
      
      current.alpha = 1
      
      animatePageView(current, forState: .expanded) {
        self.delegate?.onboardingView?(self, didSelectPage: self.pageControlView.currentPage)
      }
      
      animateSubviews(current)
      animatePageView(previous, forState: .fadeIn)
      
    case UISwipeGestureRecognizerDirection.right:
      guard pageControlView.currentPage - 1 >= 0 else {
        return
      }
      
      pageControlView.currentPage -= 1
      delegate?.onboardingView?(self, willSelectPage: pageControlView.currentPage)
      
      let next = nextPageView()
      let current = currentPageView()
      
      insertSubview(current, aboveSubview: next)
      
      maskPageView(current, state: .folded)
      
      current.alpha = 1
      
      animatePageView(current, forState: .expanded) {
        self.delegate?.onboardingView?(self, didSelectPage: self.pageControlView.currentPage)
      }
      
      animateSubviews(current)
      animatePageView(next, forState: .fadeIn)
      
      
    default:
      break
    }
  }
  
  fileprivate func currentPageView() -> PageView {
    return pageViews[pageControlView.currentPage]
  }
  
  fileprivate func nextPageView() -> PageView {
    return pageViews[pageControlView.currentPage + 1]
  }
  
  public func previousPageView() -> PageView {
    return pageViews[pageControlView.currentPage - 1]
  }
  
  // MARK: Animation
  
  internal enum State {
    case expanded
    case folded
    case fadeOut
    case fadeIn
  }
  
  fileprivate func animateSubviews(_ pageView: PageView) {
    
    let subviews: [UIView] = [
      pageView.imageView,
      pageView.titleLabel,
      pageView.descriptionLabel
    ]
    
    subviews.forEach {
      $0.transform = CGAffineTransform(translationX: 0, y: 25)
      $0.alpha = 0
    }
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0.3,
      options: [.curveEaseOut],
      
      animations: {
        subviews.forEach {
          $0.transform = CGAffineTransform.identity
          $0.alpha = 1
        }
      },
      
      completion: nil
    )
  }
  
  fileprivate func pathForState(_ state: State) -> UIBezierPath {
    let center = pageControlView.frame.midPoint
    
    return UIBezierPath(
      arcCenter: center,
      radius: state == .expanded ? frame.height * 2 : 0.1,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
  }
    
  fileprivate func maskPageView(_ pageView: PageView, state: State = .folded) {
    let shape = CAShapeLayer()
    shape.path = pathForState(state).cgPath
    pageView.layer.mask = shape
  }
  
  func animatePageView(_ pageView: PageView, forState state: State, completion: ((Void) -> Void)? = nil) {
    if state == .expanded || state == .folded {
      if let shapeLayer = pageView.layer.mask as? CAShapeLayer {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = pathForState(state).cgPath
        animation.duration = 0.7
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        if let completion = completion {
          animation.delegate = self
          
          let completionObj = CompletionObject.sharedInstance
          completionObj.completion = completion
        }
        
        shapeLayer.add(animation, forKey: nil)
      }
    } else {
      UIView.animate(withDuration: 0.8, animations: {
        pageView.alpha = state == .fadeIn ? 0 : 1
      }) 
    }

  }
  
  // MARK: Animation delegate
    
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    let completionObj = CompletionObject.sharedInstance
    completionObj.complete()
  }
  
}
