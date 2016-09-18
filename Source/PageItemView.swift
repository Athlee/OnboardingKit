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
    case `default`
    case filled
    case selected
  }
  
  // MARK: Properties
  
  public static var borderLineWidth: CGFloat = 1
  public static var borderLineColor: UIColor = UIColor.gray
  
  public var fillColor: UIColor = UIColor.red
  
  public var animated = true
  public var state: State = .default {
    didSet {
      updateState(animated)
    }
  }
  
  public var image: UIImage = UIImage() { didSet { imageView.image = image } }
  
  fileprivate let circleView = UIView()
  fileprivate let imageView = UIImageView()
  
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
  
  fileprivate func updateState(_ animated: Bool = true) {
    if self.state == .selected {
      imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
      let scale = PageControlView.radiusExpanded / PageControlView.radius
      
      let animations = { [weak self] in
        self?.imageView.alpha = 1
        self?.imageView.transform = CGAffineTransform.identity
        self?.circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
        self?.circleView.alpha = 0
      }
      
      if animated {
        UIView.animate(
          withDuration: 0.5,
          delay: 0,
          options: UIViewAnimationOptions(),
          animations: animations,
          completion: nil
        )
      } else {
        animations()
      }
    } else {
      if self.state == .default {
        circleView.backgroundColor = .clear
      }
      
      let animations = {
        self.imageView.alpha = 0
        self.imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        self.circleView.transform = CGAffineTransform.identity
        self.circleView.alpha = 1
        
        if self.state == .filled {
          self.circleView.backgroundColor = PageItemView.borderLineColor
        }
      }
      
      if animated {
        UIView.animate(
          withDuration: 0.5,
          delay: 0,
          options: UIViewAnimationOptions(),
          animations: animations,
          completion: nil
        )
      } else {
        animations()
      }
    } 
  }
  
  // MARK: Setup
  
  fileprivate func setup() {
    backgroundColor = UIColor.clear
    
    // CircleView setup
    circleView.translatesAutoresizingMaskIntoConstraints = false
    circleView.layer.cornerRadius = PageControlView.radius
    circleView.layer.borderWidth = PageItemView.borderLineWidth
    circleView.layer.borderColor = PageItemView.borderLineColor.cgColor
    circleView.layer.backgroundColor = UIColor.clear.cgColor
    
    addSubview(circleView)
    
    if #available(iOS 9.0, *) {
        let anchors = [
            circleView.widthAnchor.constraint(equalToConstant: PageControlView.radius * 2),
            circleView.heightAnchor.constraint(equalToConstant: PageControlView.radius * 2),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(anchors)
    } else {
        let _anchors = [
            circleView.anchors.widthAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.anchors.heightAnchor.constraintEqualToConstant(PageControlView.radius * 2),
            circleView.anchors.centerXAnchor.constraintEqualToAnchor(anchors.centerXAnchor),
            circleView.anchors.centerYAnchor.constraintEqualToAnchor(anchors.centerYAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(_anchors)
    }
    
    
    // ImageView setup
    imageView.isOpaque = true 
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.alpha = 0
    
    addSubview(imageView)
    
    if #available(iOS 9.0, *) {
        let imageViewAnchors = [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(imageViewAnchors)
    } else {
        let imageViewAnchors = [
            imageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            imageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            imageView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor),
            imageView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(imageViewAnchors)
    }
    
  }
  
  // MARK: Layer utils
  
  fileprivate func borderLayer() -> CALayer {
    let path = UIBezierPath(
      arcCenter: bounds.midPoint,
      radius: PageControlView.radius,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
    
    let layer = CAShapeLayer()
    layer.lineWidth = PageItemView.borderLineWidth
    layer.strokeColor = PageItemView.borderLineColor.cgColor
    layer.fillColor = UIColor.clear.cgColor
    layer.path = path.cgPath
    
    return layer
  }
  
  fileprivate func expandedCircleLayer() -> CALayer {
    let path = UIBezierPath(
      arcCenter: bounds.midPoint,
      radius: PageControlView.radiusExpanded,
      startAngle: 0,
      endAngle: CGFloat(M_PI) * 2,
      clockwise: false
    )
    
    let layer = CAShapeLayer()
    layer.lineWidth = PageItemView.borderLineWidth
    layer.strokeColor = UIColor.red.cgColor
    layer.fillColor = UIColor.red.cgColor
    layer.path = path.cgPath
    
    return layer
  }
  
}
