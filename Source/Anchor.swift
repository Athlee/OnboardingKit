//
//  Anchor.swift
//  AnchorTest
//
//  Created by Jonathan Wight on 7/10/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

#if os(OSX)
    import AppKit
    internal typealias View = NSView
#elseif os(iOS)
    import UIKit
    internal typealias View = UIView
#endif

public extension View {
    var anchors:Anchors {
        return Anchors(item:self)
    }
}

public struct Anchors {
    internal let item:View
    
    internal init(item:View) {
        self.item = item
    }
    
    public var leadingAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.Leading)
    }
    public var trailingAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.Trailing)
    }
    public var leftAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.Left)
    }
    public var rightAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.Right)
    }
    public var topAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.Top)
    }
    public var bottomAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.Bottom)
    }
    public var widthAnchor: LayoutDimension {
        return LayoutDimension(item:item, attribute:.Width)
    }
    public var heightAnchor: LayoutDimension {
        return LayoutDimension(item:item, attribute:.Height)
    }
    public var centerXAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.CenterX)
    }
    public var centerYAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.CenterY)
    }
}


// MARK: -

/*
 An NSLayoutAnchor represents an edge or dimension of a layout item.  Its concrete subclasses allow concise creation of constraints.  The idea is that instead of invoking +[NSLayoutConstraint constraintWithItem: attribute: relatedBy: toItem: attribute: multiplier: constant:] directly, you can instead do something like this:
 
 [myView.topAnchor constraintEqualToAnchor:otherView.topAnchor constant:10];
 
 The -constraint* methods are available in multiple flavors to support use of different relations and omission of unused options.
 
 */

public class LayoutAnchor {
    
    internal var item:View
    internal var attribute:NSLayoutAttribute
    
    internal init(item:View, attribute:NSLayoutAttribute) {
        self.item = item
        self.attribute = attribute
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor.
    public func constraintEqualToAnchor(anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    public func constraintGreaterThanOrEqualToAnchor(anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .GreaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    public func constraintLessThanOrEqualToAnchor(anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .LessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
    public func constraintEqualToAnchor(anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
    
    public func constraintGreaterThanOrEqualToAnchor(anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .GreaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
    
    public func constraintLessThanOrEqualToAnchor(anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .LessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
}

// MARK: -

// Axis-specific subclasses for location anchors: top/bottom, leading/trailing, baseline, etc.
public class LayoutXAxisAnchor : LayoutAnchor {
}

public class LayoutYAxisAnchor : LayoutAnchor {
}

// MARK: -

/*
 This layout anchor subclass is used for sizes (width & height).
 */

public class LayoutDimension : LayoutAnchor {
    
    // These methods return an inactive constraint of the form thisVariable = constant.
    public func constraintEqualToConstant(c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute:.NotAnAttribute, multiplier: 1.0, constant: c)
    }
    
    public func constraintGreaterThanOrEqualToConstant(c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute:.NotAnAttribute, multiplier: 1.0, constant: c)
    }
    
    public func constraintLessThanOrEqualToConstant(c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .LessThanOrEqual, toItem: nil, attribute:.NotAnAttribute, multiplier: 1.0, constant: c)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier.
    public func constraintEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    public func constraintGreaterThanOrEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .GreaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    public func constraintLessThanOrEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .LessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier + constant.
    public func constraintEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .Equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
    
    public func constraintGreaterThanOrEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .GreaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
    
    public func constraintLessThanOrEqualToAnchor(anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .LessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
}