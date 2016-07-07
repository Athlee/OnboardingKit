//
//  OnboardingView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

internal protocol Completion {
  func complete()
}

internal final class CompletionObject: Completion {
  internal var completion: ((Void) -> Void)?
  
  internal static let sharedInstance = CompletionObject()
  
  private init() { }
  
  internal func complete() {
    completion?()
    completion = nil 
  }
}

public final class OnboardingView: UIView {
  
  // MARK: Properties 
  
  public let pageControlView = PageControlView()
  
  public weak var dataSource: OnboardingViewDataSource? { didSet { reload() } }
  
  public weak var delegate: OnboardingViewDelegate? {
    didSet {
      for (i, pageView) in pageViews.enumerate() {
        delegate?.onboardingView?(self, configurePageView: pageView, atPage: i)
      }
    }
  }
  
  public var topContainerOffset: CGFloat = 8 { didSet { pageViews.forEach { $0.topContainerOffset = topContainerOffset } } }
  public var bottomPageControlViewOffset: CGFloat = 32 { didSet { bottomPageControlViewAnchor.constant = -bottomPageControlViewOffset } }
  
  private var bottomPageControlViewAnchor: NSLayoutConstraint!
  
  private var pageViews: [PageView] = []
  private var configurations: [Int: OnboardingConfiguration] = [:]
  
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
  
  private var layouted = false
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    if !layouted {
      layouted = true
      
      for (i, pageView) in pageViews.enumerate() {
        if i > 0 {
          maskPageView(pageView, state: .Folded)
        }
      }
    }
  }
  
  // MARK: Setup
  
  private func setup() {
    // Refresh
    topContainerOffset = 8
    
    // Setup PageControlView
    insertSubview(pageControlView, atIndex: Int.max)
    
    pageControlView.translatesAutoresizingMaskIntoConstraints = false
    bottomPageControlViewAnchor = pageControlView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -bottomPageControlViewOffset)!
    
    let pageControlViewAnchors = [
      pageControlView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 8),
      pageControlView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant:  -8),
      bottomPageControlViewAnchor,
      pageControlView.heightAnchor.constraintEqualToConstant(PageControlView.radiusExpanded)
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(pageControlViewAnchors)
    
    // Add resture recognizers
    addRecognizers()
  }
  
  private func reload() {
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
  
  private func preparedPageView(at page: Int) -> PageView {
    guard let dataSource = dataSource else {
      fatalError("DataSource not found!")
    }
    
    let config = dataSource.onboardingView(self, configurationForPage: page)
    configurations[page] = config
    
    let pageView = PageView()
    
    insertSubview(pageView, belowSubview: pageControlView)
    
    pageView.translatesAutoresizingMaskIntoConstraints = false
    
    let anchors = [
      pageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      pageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      pageView.topAnchor.constraintEqualToAnchor(topAnchor),
      pageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(anchors)
    
    pageView.configuration = config
    
    return pageView
  }
  
  private func addRecognizers() {
    let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(OnboardingView.didRecognizeSwipe(_:)))
    leftSwipeRecognizer.direction = .Left
    
    let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(OnboardingView.didRecognizeSwipe(_:)))
    rightSwipeRecognizer.direction = .Right
    
    addGestureRecognizer(leftSwipeRecognizer)
    addGestureRecognizer(rightSwipeRecognizer)
  }
  
  internal func didRecognizeSwipe(recognizer: UISwipeGestureRecognizer) {
    switch recognizer.direction {
    case UISwipeGestureRecognizerDirection.Left:
      guard pageControlView.currentPage + 1 < pageControlView.pages else {
        return
      }
      
      pageControlView.currentPage += 1
      delegate?.onboardingView?(self, willSelectPage: pageControlView.currentPage)
      
      let previous = previousPageView()
      let current = currentPageView()
      
      insertSubview(current, aboveSubview: previous)
      
      maskPageView(current, state: .Folded)
      
      current.alpha = 1
      
      animatePageView(current, forState: .Expanded) {
        self.delegate?.onboardingView?(self, didSelectPage: self.pageControlView.currentPage)
      }
      
      animateSubviews(current)
      animatePageView(previous, forState: .FadeIn)
      
    case UISwipeGestureRecognizerDirection.Right:
      guard pageControlView.currentPage - 1 >= 0 else {
        return
      }
      
      pageControlView.currentPage -= 1
      delegate?.onboardingView?(self, willSelectPage: pageControlView.currentPage)
      
      let next = nextPageView()
      let current = currentPageView()
      
      insertSubview(current, aboveSubview: next)
      
      maskPageView(current, state: .Folded)
      
      current.alpha = 1
      
      animatePageView(current, forState: .Expanded) {
        self.delegate?.onboardingView?(self, didSelectPage: self.pageControlView.currentPage)
      }
      
      animateSubviews(current)
      animatePageView(next, forState: .FadeIn)
      
      
    default:
      break
    }
  }
  
  private func currentPageView() -> PageView {
    return pageViews[pageControlView.currentPage]
  }
  
  private func nextPageView() -> PageView {
    return pageViews[pageControlView.currentPage + 1]
  }
  
  public func previousPageView() -> PageView {
    return pageViews[pageControlView.currentPage - 1]
  }
  
  // MARK: Animation
  
  internal enum State {
    case Expanded
    case Folded
    case FadeOut
    case FadeIn
  }
  
  private func animateSubviews(pageView: PageView) {
    
    let subviews = [
      pageView.imageView,
      pageView.titleLabel,
      pageView.descriptionLabel
    ]
    
    subviews.forEach {
      $0.transform = CGAffineTransformMakeTranslation(0, 25)
      $0.alpha = 0
    }
    
    UIView.animateWithDuration(
      0.5,
      delay: 0.3,
      options: [.CurveEaseOut],
      
      animations: {
        subviews.forEach {
          $0.transform = CGAffineTransformIdentity
          $0.alpha = 1
        }
      },
      
      completion: nil
    )
  }
  
  private func pathForState(state: State) -> UIBezierPath {
    let center = pageControlView.frame.midPoint
    
    return UIBezierPath(
      arcCenter: center,
      radius: state == .Expanded ? frame.height * 2 : 0.1,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
  }
  
  private func maskPageView(pageView: PageView, state: State = .Folded) {
    let shape = CAShapeLayer()
    shape.path = pathForState(state).CGPath
    pageView.layer.mask = shape
  }
  
  func animatePageView(pageView: PageView, forState state: State, completion: ((Void) -> Void)? = nil) {
    if state == .Expanded || state == .Folded {
      if let shapeLayer = pageView.layer.mask as? CAShapeLayer {
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = pathForState(state).CGPath
        animation.duration = 0.7
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        if let completion = completion {
          animation.delegate = self
          
          let completionObj = CompletionObject.sharedInstance
          completionObj.completion = completion
        }
        
        shapeLayer.addAnimation(animation, forKey: nil)
      }
    } else {
      UIView.animateWithDuration(0.8) {
        pageView.alpha = state == .FadeIn ? 0 : 1
      }
    }

  }
  
  // MARK: Animation delegate 
  
  public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    let completionObj = CompletionObject.sharedInstance
    completionObj.complete()
  }
  
}
