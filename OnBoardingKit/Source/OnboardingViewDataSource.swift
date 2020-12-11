//
//  OnboardingViewDataSource.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public protocol OnboardingViewDataSource: class {
  func numberOfPages() -> Int
  func onboardingView(_ onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration
}
