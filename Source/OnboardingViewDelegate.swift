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
  optional func onboardingView(onboardingView: OnboardingView, willSelectPage page: Int)
  optional func onboardingView(onboardingView: OnboardingView, didSelectPage page: Int)
  optional func onboardingView(onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int)
}