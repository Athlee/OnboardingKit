//
//  UILayoutPriority.swift
//  OnboardingKit Swift3
//
//  Created by Carlos barros on 29/06/2021.
//  Copyright © 2021 Athlee. All rights reserved.
//
import UIKit
import Foundation

extension UILayoutPriority {
    static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        let raw = lhs.rawValue + rhs
        return UILayoutPriority(rawValue:raw)
    }
}

// MARK: - Allow to pass an integer value to the functions depending on UILayoutPriority
extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self.init(Float(value))
    }
}
