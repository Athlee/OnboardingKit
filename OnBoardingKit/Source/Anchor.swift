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
        return LayoutXAxisAnchor(item:item, attribute:.leading)
    }
    public var trailingAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.trailing)
    }
    public var leftAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.left)
    }
    public var rightAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.right)
    }
    public var topAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.top)
    }
    public var bottomAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.bottom)
    }
    public var widthAnchor: LayoutDimension {
        return LayoutDimension(item:item, attribute:.width)
    }
    public var heightAnchor: LayoutDimension {
        return LayoutDimension(item:item, attribute:.height)
    }
    public var centerXAnchor: LayoutXAxisAnchor {
        return LayoutXAxisAnchor(item:item, attribute:.centerX)
    }
    public var centerYAnchor: LayoutYAxisAnchor {
        return LayoutYAxisAnchor(item:item, attribute:.centerY)
    }
}


// MARK: -

/*
 An NSLayoutAnchor represents an edge or dimension of a layout item.  Its concrete subclasses allow concise creation of constraints.  The idea is that instead of invoking +[NSLayoutConstraint constraintWithItem: attribute: relatedBy: toItem: attribute: multiplier: constant:] directly, you can instead do something like this:
 
 [myView.topAnchor constraintEqualToAnchor:otherView.topAnchor constant:10];
 
 The -constraint* methods are available in multiple flavors to support use of different relations and omission of unused options.
 
 */

open class LayoutAnchor {
    
    internal var item:View
    internal var attribute:NSLayoutAttribute
    
    internal init(item:View, attribute:NSLayoutAttribute) {
        self.item = item
        self.attribute = attribute
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor.
    open func constraintEqualToAnchor(_ anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    open func constraintGreaterThanOrEqualToAnchor(_ anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    open func constraintLessThanOrEqualToAnchor(_ anchor: LayoutAnchor) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: 0.0)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
    open func constraintEqualToAnchor(_ anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
    
    open func constraintGreaterThanOrEqualToAnchor(_ anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
    
    open func constraintLessThanOrEqualToAnchor(_ anchor: LayoutAnchor, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: 1.0, constant: c)
    }
}

// MARK: -

// Axis-specific subclasses for location anchors: top/bottom, leading/trailing, baseline, etc.
open class LayoutXAxisAnchor : LayoutAnchor {
}

open class LayoutYAxisAnchor : LayoutAnchor {
}

// MARK: -

/*
 This layout anchor subclass is used for sizes (width & height).
 */

open class LayoutDimension : LayoutAnchor {
    
    // These methods return an inactive constraint of the form thisVariable = constant.
    open func constraintEqualToConstant(_ c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: c)
    }
    
    open func constraintGreaterThanOrEqualToConstant(_ c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: c)
    }
    
    open func constraintLessThanOrEqualToConstant(_ c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, toItem: nil, attribute:.notAnAttribute, multiplier: 1.0, constant: c)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier.
    open func constraintEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    open func constraintGreaterThanOrEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    open func constraintLessThanOrEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: 0)
    }
    
    // These methods return an inactive constraint of the form thisAnchor = otherAnchor * multiplier + constant.
    open func constraintEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
    
    open func constraintGreaterThanOrEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
    
    open func constraintLessThanOrEqualToAnchor(_ anchor: LayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, toItem: anchor.item, attribute: anchor.attribute, multiplier: m, constant: c)
    }
}
