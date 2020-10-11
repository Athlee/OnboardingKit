//
//  PageView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit
//import TZStackView

public protocol Configurable {
  associatedtype Configuration
  func configure(_ configuration: Configuration)
}

public final class PageView: UIView {
  
  // MARK: Properties
  
  public var configuration: OnboardingConfiguration! { didSet { configure(configuration) } }
  
  fileprivate let topStackView = TZStackView()
  fileprivate let bottomStackView = TZStackView()
  
  public var image: UIImage = UIImage() { didSet { imageView.image = image } }
  public var pageTitle: String = "" { didSet { titleLabel.text = pageTitle } }
  public var pageDescription: String = "" { didSet { descriptionLabel.text = pageDescription } }
  
  public lazy var imageView = UIImageView()
  public lazy var titleLabel = UILabel()
  public lazy var descriptionLabel = UILabel()
  
  public var backgroundImage: UIImage = UIImage() { didSet { backgroundImageView.image = backgroundImage } }
  public var bottomBackgroundImage: UIImage = UIImage() { didSet { bottomBackgroundImageView.image = bottomBackgroundImage } }
  public var topBackgroundImage: UIImage = UIImage() { didSet { topBackgroundImageView.image = topBackgroundImage } }
  
  fileprivate var backgroundImageView = UIImageView()
  fileprivate var topBackgroundImageView = UIImageView()
  fileprivate var bottomBackgroundImageView = UIImageView()
  
  public var topContainerOffset: CGFloat = 8 { didSet { topContainerAnchor.constant = topContainerOffset } }
  public var bottomContainerOffset: CGFloat = 8 { didSet { bottomContainerAnchor.constant = bottomContainerOffset } }
  
  public var offsetBetweenContainers: CGFloat = 8 {
    didSet {
      topContainerHeightAnchor.constant = -topContainerOffset - offsetBetweenContainers / 2
      bottomContainerHeightAnchor.constant = -bottomContainerOffset - offsetBetweenContainers / 2
    }
  }
  
  fileprivate var topContainerAnchor: NSLayoutConstraint!
  fileprivate var bottomContainerAnchor: NSLayoutConstraint!
  fileprivate var topContainerHeightAnchor: NSLayoutConstraint!
  fileprivate var bottomContainerHeightAnchor: NSLayoutConstraint!
  
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
  
  // MARK: Setup 
  
  fileprivate func setup() {
    addSubview(topStackView)
    addSubview(bottomStackView)
    
    setupTopStackView()
    setupBottomStackView()
    addBackgroundImageViews()
  }
  
  fileprivate func addBackgroundImageViews() {
    setupBackgroundImageView()
    setupTopBackgroundImageView()
    setupBottomBackgroundImageView()
  }
  
  fileprivate func setupBackgroundImageView() {
    insertSubview(backgroundImageView, at: 0)
    
    backgroundImageView.isOpaque = true
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false 
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.image = backgroundImage
    
    if #available(iOS 9.0, *) {
        let backgroundAnchors = [
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(backgroundAnchors)
    } else {
        let backgroundAnchors = [
            backgroundImageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            backgroundImageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            backgroundImageView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor),
            backgroundImageView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(backgroundAnchors)
    }
  }
  
  fileprivate func setupTopBackgroundImageView() {
    insertSubview(topBackgroundImageView, at: 1)
    
    topBackgroundImageView.isOpaque = true
    topBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    topBackgroundImageView.contentMode = .scaleToFill
    topBackgroundImageView.image = topBackgroundImage
    
    if #available(iOS 9.0, *) {
        let bottomBackgroundAnchors = [
            topBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            topBackgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomBackgroundAnchors)
    } else {
        let bottomBackgroundAnchors = [
            topBackgroundImageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            topBackgroundImageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            topBackgroundImageView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor),
            topBackgroundImageView.anchors.heightAnchor.constraintEqualToAnchor(anchors.heightAnchor, multiplier: 0.5)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomBackgroundAnchors)
    }
  }
  
  fileprivate func setupBottomBackgroundImageView() {
    insertSubview(bottomBackgroundImageView, at: 1)
    
    bottomBackgroundImageView.isOpaque = true
    bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    bottomBackgroundImageView.contentMode = .scaleToFill
    bottomBackgroundImageView.image = bottomBackgroundImage
    
    if #available(iOS 9.0, *) {
        let bottomBackgroundAnchors = [
            bottomBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBackgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomBackgroundAnchors)
    } else {
        let bottomBackgroundAnchors = [
            bottomBackgroundImageView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor),
            bottomBackgroundImageView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor),
            bottomBackgroundImageView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor),
            bottomBackgroundImageView.anchors.heightAnchor.constraintEqualToAnchor(anchors.heightAnchor, multiplier: 0.5)
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomBackgroundAnchors)
    }
  }
  
  fileprivate func setupTopStackView() {
    // Top StackView layout setup
    topStackView.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 9.0, *) {
        topContainerAnchor = topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topContainerOffset)
        topContainerHeightAnchor = topStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5, constant: -topContainerOffset - offsetBetweenContainers / 2)
    } else {
        topContainerAnchor = topStackView.anchors.topAnchor.constraintEqualToAnchor(anchors.topAnchor, constant: topContainerOffset)
        topContainerHeightAnchor = topStackView.anchors.heightAnchor.constraintEqualToAnchor(anchors.heightAnchor, multiplier: 0.5, constant: -topContainerOffset - offsetBetweenContainers / 2)
    }
    
    if #available(iOS 9.0, *) {
        let topAnchors = [
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: topContainerOffset),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -topContainerOffset),
            topContainerAnchor,
            topContainerHeightAnchor
            ].flatMap { $0 }
        NSLayoutConstraint.activate(topAnchors)
    } else {
        let topAnchors = [
            topStackView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor, constant: topContainerOffset),
            topStackView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor, constant: -topContainerOffset),
            topContainerAnchor,
            topContainerHeightAnchor
            ].flatMap { $0 }
        NSLayoutConstraint.activate(topAnchors)
    }
    
    // StackViews common setup
    topStackView.axis = .vertical
    topStackView.alignment = .center
    topStackView.distribution = .fill
    topStackView.spacing = -10 // TODO: Make inspectable
    
    // Add subviews to the top StackView
    topStackView.addArrangedSubview(imageView)
    topStackView.addArrangedSubview(titleLabel)
    
    // Intial setup for top StackView subviews
    imageView.isOpaque = true 
    imageView.contentMode = .scaleAspectFit
    titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
    titleLabel.textAlignment = .center
    titleLabel.text = pageTitle
    //titleLabel.backgroundColor = .redColor()
    
    // This way the StackView knows how to size & align subviews.
    imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
    titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
  }
  
  fileprivate func setupBottomStackView() {
    // Bottom StackView layout setup
    bottomStackView.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 9.0, *) {
        bottomContainerAnchor = bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomContainerOffset)
        bottomContainerHeightAnchor = bottomStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5, constant: -bottomContainerOffset - offsetBetweenContainers / 2)
    } else {
        bottomContainerAnchor = bottomStackView.anchors.bottomAnchor.constraintEqualToAnchor(anchors.bottomAnchor, constant: -bottomContainerOffset)
        bottomContainerHeightAnchor = bottomStackView.anchors.heightAnchor.constraintEqualToAnchor(anchors.heightAnchor, multiplier: 0.5, constant: -bottomContainerOffset - offsetBetweenContainers / 2)
    }
    
    if #available(iOS 9.0, *) {
        let bottomAnchors = [
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bottomContainerOffset),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bottomContainerOffset),
            bottomContainerAnchor,
            bottomContainerHeightAnchor
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomAnchors)
    } else {
        let bottomAnchors = [
            bottomStackView.anchors.leadingAnchor.constraintEqualToAnchor(anchors.leadingAnchor, constant: bottomContainerOffset),
            bottomStackView.anchors.trailingAnchor.constraintEqualToAnchor(anchors.trailingAnchor, constant: -bottomContainerOffset),
            bottomContainerAnchor,
            bottomContainerHeightAnchor
            ].flatMap { $0 }
        NSLayoutConstraint.activate(bottomAnchors)
    }
    
    // StackViews common setup
    bottomStackView.axis = .vertical
    bottomStackView.alignment = .center
    bottomStackView.distribution = .fill
    bottomStackView.spacing = 0 // TODO: Make inspectable 
    
    // Add subviews to the bottom StackView
    bottomStackView.addArrangedSubview(descriptionLabel)
    
    // Intial setup for top StackView subviews
    descriptionLabel.font = UIFont.systemFont(ofSize: 17)
    descriptionLabel.textAlignment = .center
    descriptionLabel.text = pageDescription
    descriptionLabel.numberOfLines = 0
    //descriptionLabel.backgroundColor = .orangeColor()
  }
  
}

// MARK: - Configurable 

extension PageView: Configurable {
  public func configure(_ configuration: OnboardingConfiguration) {
    image = configuration.image
    pageTitle = configuration.pageTitle
    pageDescription = configuration.pageDescription
    
    if let backgroundImage = configuration.backgroundImage {
      self.backgroundImage = backgroundImage
    }
    
    if let bottomBackgroundImage = configuration.bottomBackgroundImage {
      self.bottomBackgroundImage = bottomBackgroundImage
    }
  }
}
