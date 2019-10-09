//
//  CompletionObject.swift
//  Athlee-Onboarding
//
//  Created by mac on 07/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import Foundation

internal protocol Completion {
  func complete()
}

internal final class CompletionObject: Completion {
  internal var completion: (() -> Void)?
  
  internal static let sharedInstance = CompletionObject()
  
  fileprivate init() { }
  
  internal func complete() {
    completion?()
    completion = nil
  }
}
