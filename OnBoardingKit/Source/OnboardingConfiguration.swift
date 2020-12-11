//
//  OnboardingConfiguration.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public struct OnboardingConfiguration {
  public let image: UIImage
  public let itemImage: UIImage
  public let pageTitle: String
  public let pageDescription: String
  
  public let backgroundImage: UIImage?
  public let topBackgroundImage: UIImage?
  public let bottomBackgroundImage: UIImage?
  
  public init(image: UIImage,
              itemImage: UIImage,
              pageTitle: String,
              pageDescription: String,
              backgroundImage: UIImage? = nil,
              topBackgroundImage: UIImage? = nil,
              bottomBackgroundImage: UIImage? = nil) {
    self.image = image
    self.itemImage = itemImage
    self.pageTitle = pageTitle
    self.pageDescription = pageDescription
    self.backgroundImage = backgroundImage
    self.topBackgroundImage = topBackgroundImage
    self.bottomBackgroundImage = bottomBackgroundImage
  }
}