//
//  DeviceTarget.swift
//  Athlee-Onboarding
//
//  Created by mac on 07/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public struct DeviceTarget {
  public static let CURRENT_DEVICE: CGFloat = UIScreen.main.bounds.height
  
  public static let IPHONE_4: CGFloat = 480
  public static let IPHONE_5: CGFloat = 568
  public static let IPHONE_6: CGFloat = 667
  public static let IPHONE_6_Plus: CGFloat = 736
  
  public static let IS_IPHONE_4 = UIScreen.main.bounds.height == IPHONE_4
  public static let IS_IPHONE_5 = UIScreen.main.bounds.height == IPHONE_5
  public static let IS_IPHONE_6 = UIScreen.main.bounds.height == IPHONE_6
  public static let IS_IPHONE_6_Plus = UIScreen.main.bounds.height == IPHONE_6_Plus
}
