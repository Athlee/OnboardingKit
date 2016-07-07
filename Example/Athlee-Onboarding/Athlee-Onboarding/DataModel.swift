//
//  DataModel.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public final class DataModel: NSObject, OnboardingViewDelegate, OnboardingViewDataSource {
  
  public var didShow: ((Int) -> Void)?
  public var willShow: ((Int) -> Void)?
  
  public func numberOfPages() -> Int {
    return 5
  }
  
  public func onboardingView(onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration {
    switch page {
      
    case 0:
      return OnboardingConfiguration(
        image: UIImage(named: "PageHeartImage")!,
        itemImage: UIImage(named: "ItemHeartIcon")!,
        pageTitle: "PhotoFIT",
        pageDescription: "A new kind of fittness tracking! \n\n100% free, because great health should be accessible to all!",
        backgroundImage: UIImage(named: "BackgroundRed"),
        topBackgroundImage: nil,
        bottomBackgroundImage: UIImage(named: "WavesImage")
      )
      
    case 1:
      return OnboardingConfiguration(
        image: UIImage(named: "PageMetricsImage")!,
        itemImage: UIImage(named: "ItemMetricsIcon")!,
        pageTitle: "Body Metrics",
        pageDescription: "Body metrics will never be the same! \n\nTrack bodyweight, body fat, and add a snap shot of your progress!",
        backgroundImage: UIImage(named: "BackgroundBlue"),
        topBackgroundImage: nil,
        bottomBackgroundImage: UIImage(named: "WavesImage")
      )
      
    case 2:
      return OnboardingConfiguration(
        image: UIImage(named: "PageActivityImage")!,
        itemImage: UIImage(named: "ItemActivityIcon")!,
        pageTitle: "Activity",
        pageDescription: "View activity collected by your fitness trackers and your other mobile apps! \n\nData has never been more beautiful or easier to understand!",
        backgroundImage: UIImage(named: "BackgroundOrange"),
        topBackgroundImage: nil,
        bottomBackgroundImage: UIImage(named: "WavesImage")
      )
      
    case 3:
      return OnboardingConfiguration(
        image: UIImage(named: "PageNutritionImage")!,
        itemImage: UIImage(named: "ItemNutritionIcon")!,
        pageTitle: "Nutrition",
        pageDescription: "Nutrition tracking can be difficult! \n\nContinue to use your favorite calorie tracking apps if you want, but check out your results here and make sure your macros are in check!",
        backgroundImage: UIImage(named: "BackgroundGreen"),
        topBackgroundImage: nil,
        bottomBackgroundImage: UIImage(named: "WavesImage")
      )
      
    case 4:
      return OnboardingConfiguration(
        image: UIImage(named: "PageTimelapseImage")!,
        itemImage: UIImage(named: "ItemTimelapseIcon")!,
        pageTitle: "PhotoLAPSE",
        pageDescription: "Your progress photos are being put to good use! \n\nThe photoLAPSE feature allows you to view your results over custom time periods!",
        backgroundImage: UIImage(named: "BackgroundPurple"),
        topBackgroundImage: nil,
        bottomBackgroundImage: UIImage(named: "WavesImage")
      )
      
    default:
      fatalError("Out of range!")
    }
  }
  
  public func onboardingView(onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int) {
    pageView.titleLabel.textColor = UIColor.whiteColor()
    pageView.titleLabel.layer.shadowOpacity = 0.6
    pageView.titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
    pageView.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
    pageView.titleLabel.layer.shouldRasterize = true
    pageView.titleLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
    
    if DeviceTarget.IS_IPHONE_4 {
      pageView.titleLabel.font = UIFont.boldSystemFontOfSize(30)
      pageView.descriptionLabel.font = UIFont.systemFontOfSize(15)
    }
  }
  
  public func onboardingView(onboardingView: OnboardingView, didSelectPage page: Int) {
    print("Did select pge \(page)")
    didShow?(page)
  }
  
  public func onboardingView(onboardingView: OnboardingView, willSelectPage page: Int) {
    print("Will select page \(page)")
    willShow?(page)
  }
}