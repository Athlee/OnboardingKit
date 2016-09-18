//
//  PageControlView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit
//import TZStackView

public final class PageControlView: UIView {
  
  // MARK: Properties 
  
  public static var radius: CGFloat = 5
  public static var radiusExpanded: CGFloat = 17
  public static var interitemSpace: CGFloat = 5
  
  public var currentPage: Int = 0 {
    didSet {
      if currentPage >= 0 && currentPage < pages {
        centerSelectedItem()
        
        let prevItem = items[oldValue]
        let item = items[currentPage]
        
        if oldValue < currentPage {
          prevItem.state = .filled
        } else {
          prevItem.state = .default
        }
        
        item.state = .selected 
      } else {
        if currentPage >= pages {
          currentPage = pages - 1
        } else {
          currentPage = 0
        }
      }
    }
  }
  
  public var pages: Int = 0 { didSet { reload() } }
  
  public var items: [PageItemView] = []
  
  fileprivate var stackView = TZStackView()
  fileprivate var stackViewCenterXAnchor: NSLayoutConstraint!
  fileprivate var stackViewWidthAnchor: NSLayoutConstraint!
  
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
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    centerSelectedItem(false)
  }
  
  // MARK: Setup
  
  fileprivate func setup() {
    addSubview(stackView)
    
    // Common StackView setup
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    
    stackView.spacing = -40 // TODO: Make it inspectable 

    layer.masksToBounds = false
    
    let width = PageControlView.radiusExpanded * 2 * CGFloat(pages) + CGFloat(pages) * PageControlView.interitemSpace
    let height = PageControlView.radiusExpanded * 2
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackViewCenterXAnchor = stackView.anchors.centerXAnchor.constraintEqualToAnchor(anchors.centerXAnchor)
    stackViewWidthAnchor = stackView.anchors.widthAnchor.constraintEqualToConstant(width)

    if #available(iOS 9.0, *) {
        let anchors = [
            stackViewWidthAnchor,
            stackView.heightAnchor.constraint(equalToConstant: height),
            stackViewCenterXAnchor,
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(anchors)
    } else {
        let _anchors = [
            stackViewWidthAnchor,
            stackView.anchors.heightAnchor.constraintEqualToConstant(height),
            stackViewCenterXAnchor,
            stackView.anchors.centerYAnchor.constraintEqualToAnchor(anchors.centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(_anchors)
    }
    
    for _ in 0..<pages {
      let item = PageItemView()
      items += [item]
      stackView.addArrangedSubview(item)
    }
    
    if !items.isEmpty {
      let selectedItem = items[0]
      selectedItem.animated = false
      selectedItem.state = .selected
      selectedItem.animated = true
      
      centerSelectedItem(false)
    }
  }
  
  fileprivate func reload() {
    subviews.forEach { $0.removeFromSuperview() }
    
    stackView = TZStackView()
    stackViewWidthAnchor = nil
    stackViewCenterXAnchor = nil
    items = []
    
    setup()
  }
  
  fileprivate func centerSelectedItem(_ animated: Bool = true) {
    let item = items[currentPage]
    let delta = stackView.bounds.midX - item.frame.midX
    stackViewCenterXAnchor.constant = delta
  
    if animated {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.layoutIfNeeded()
            },
        
            completion: nil
      )
    } else {
      stackView.layoutIfNeeded()
    }
  }
}
