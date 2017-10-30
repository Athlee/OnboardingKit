//
//  OnboardingViewDelegate.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

@objc
public protocol OnboardingViewDelegate: class {
  @objc optional func onboardingView(_ onboardingView: OnboardingView, willSelectPage page: Int)
  @objc optional func onboardingView(_ onboardingView: OnboardingView, didSelectPage page: Int)
  @objc optional func onboardingView(_ onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int)
}
