//
//  PageItemView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public final class PageItemView: UIView {
  
  public enum State {
    case Default
    case Filled
    case Selected
  }
  
  // MARK: Properties
  
  public static var borderLineWidth: CGFloat = 1
  public static var borderLineColor: UIColor = UIColor.grayColor()
  
  public var fillColor: UIColor = UIColor.redColor()
  
  public var animated = true
  public var state: State = .Default {
    didSet {
      updateState(animated: animated)
    }
  }
  
  public var image: UIImage = UIImage() { didSet { imageView.image = image } }
  
  private let circleView = UIView()
  private let imageView = UIImageView()
  
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
  
  // MARK: Animation
  
  private func updateState(animated animated: Bool = true) {
    if self.state == .Selected {
      imageView.transform = CGAffineTransformMakeScale(0.2, 0.2)
      let scale = PageControlView.radiusExpanded / PageControlView.radius
      
      let animations = { [weak self] in
        self?.imageView.alpha = 1
        self?.imageView.transform = CGAffineTransformIdentity
        self?.circleView.transform = CGAffineTransformMakeScale(scale, scale)
        self?.circleView.alpha = 0
      }
      
      if animated {
        UIView.animateWithDuration(
          0.5,
          delay: 0,
          options: [.CurveEaseInOut],
          animations: animations,
          completion: nil
        )
      } else {
        animations()
      }
    } else {
      if self.state == .Default {
        circleView.backgroundColor = .clearColor()
      }
      
      let animations = {
        self.imageView.alpha = 0
        self.imageView.transform = CGAffineTransformMakeScale(0.2, 0.2)
        self.circleView.transform = CGAffineTransformIdentity
        self.circleView.alpha = 1
        
        if self.state == .Filled {
          self.circleView.backgroundColor = PageItemView.borderLineColor
        }
      }
      
      if animated {
        UIView.animateWithDuration(
          0.5,
          delay: 0,
          options: [.CurveEaseInOut],
          animations: animations,
          completion: nil
        )
      } else {
        animations()
      }
    } 
  }
  
  // MARK: Setup
  
  private func setup() {
    backgroundColor = UIColor.clearColor()
    
    // CircleView setup
    circleView.translatesAutoresizingMaskIntoConstraints = false
    circleView.layer.cornerRadius = PageControlView.radius
    circleView.layer.borderWidth = PageItemView.borderLineWidth
    circleView.layer.borderColor = PageItemView.borderLineColor.CGColor
    circleView.layer.backgroundColor = UIColor.clearColor().CGColor
    
    addSubview(circleView)
    
    if #available(iOS 9.0, *) {
        let anchors = [
            circleView.widthAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.heightAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            circleView.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activateConstraints(anchors)
    } else {
        let _anchors = [
            circleView.anchors.widthAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.anchors.heightAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.anchors.centerXAnchor.constraintEqualToAnchor(anchors.centerXAnchor),
            circleView.anchors.centerYAnchor.constraintEqualToAnchor(anchors.centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activateConstraints(_anchors)
    }
    
    
    // ImageView setup
    imageView.opaque = true 
    imageView.contentMode = .ScaleAspectFit
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.alpha = 0
    
    addSubview(imageView)
    
    if #available(iOS 9.0, *) {
        let imageViewAnchors = [
            imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            imageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            imageView.topAnchor.constraintEqualToAnchor(topAnchor),
            imageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activateConstraints(imageViewAnchors)
    } else {
        let imageViewAnchors = [
            imageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            imageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            imageView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor),
            imageView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activateConstraints(imageViewAnchors)
    }
    
  }
  
  // MARK: Layer utils
  
  private func borderLayer() -> CALayer {
    let path = UIBezierPath(
      arcCenter: bounds.midPoint,
      radius: PageControlView.radius,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
    
    let layer = CAShapeLayer()
    layer.lineWidth = PageItemView.borderLineWidth
    layer.strokeColor = PageItemView.borderLineColor.CGColor
    layer.fillColor = UIColor.clearColor().CGColor
    layer.path = path.CGPath
    
    return layer
  }
  
  private func expandedCircleLayer() -> CALayer {
    let path = UIBezierPath(
      arcCenter: bounds.midPoint,
      radius: PageControlView.radiusExpanded,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
    
    let layer = CAShapeLayer()
    layer.lineWidth = PageItemView.borderLineWidth
    layer.strokeColor = UIColor.redColor().CGColor
    layer.fillColor = UIColor.redColor().CGColor
    layer.path = path.CGPath
    
    return layer
  }
  
}