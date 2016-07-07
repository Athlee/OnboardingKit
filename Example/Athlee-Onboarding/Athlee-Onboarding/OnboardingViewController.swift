//
//  OnboardingViewController.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public final class OnboardingViewController: UIViewController {

  // MARK: Outlets 
  
  @IBOutlet weak var onboardingView: OnboardingView!
  @IBOutlet weak var nextButton: UIButton!
  
  // MARK: Properties 
  
  private let model = DataModel()
  
  // MARK: Life cycle 
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    nextButton.alpha = 0
    
    onboardingView.dataSource = model
    onboardingView.delegate = model
    
    model.didShow = { page in
      if page == 4 {
        UIView.animateWithDuration(0.3) {
          self.nextButton.alpha = 1
        }
      }
    }
    
    model.willShow = { page in
      if page != 4 {
        self.nextButton.alpha = 0
      }
    }
  }
  
  public override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

}
