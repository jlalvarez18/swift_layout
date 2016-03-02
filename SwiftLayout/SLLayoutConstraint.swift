//
//  SLLayoutConstraint.swift
//  Plugd Mac
//
//  Created by Juan Alvarez on 2/9/16.
//  Copyright © 2016 Juan Alvarez. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import Cocoa
#endif

// MARK: - Batch Constraint Creation -

public extension NSLayoutConstraint {
    
    internal class ConstraintsGroup {
        var constraints: LayoutConstraintsArray
        
        init(constraints: LayoutConstraintsArray) {
            self.constraints = constraints
        }
    }
    
    internal static var arraysOfCreatedConstraints = [ConstraintsGroup]()
    private static var isInstallingConstraints = false
    
    internal class func currentConstraintsGroup() -> ConstraintsGroup? {
        return arraysOfCreatedConstraints.last
    }
    
    internal class func preventAutomaticConstraintInstallation() -> Bool {
        return !isInstallingConstraints && arraysOfCreatedConstraints.count > 0
    }
    
    public class func autoCreateAndInstallConstraints(block: SLConstraintsBlock) -> LayoutConstraintsArray {
        let createdConstraints = autoCreateConstrainsWithoutInstalling(block)
        
        isInstallingConstraints = true
        
        createdConstraints.autoInstall()
        
        isInstallingConstraints = false
        
        return createdConstraints
    }
    
    public class func autoCreateConstrainsWithoutInstalling(block: SLConstraintsBlock) -> LayoutConstraintsArray {
        arraysOfCreatedConstraints.append(ConstraintsGroup(constraints: []))
        
        block()
        
        let createdConstraints = currentConstraintsGroup()
        
        arraysOfCreatedConstraints.removeLast()
        
        return createdConstraints!.constraints
    }
    
    public func autoInstall() {
        applyGlobalState()
        
        if NSLayoutConstraint.preventAutomaticConstraintInstallation() {
            let group = NSLayoutConstraint.currentConstraintsGroup()!
            
            group.constraints.append(self)
        } else {
            active = true
        }
    }
    
    public func autoRemove() {
        active = false
    }
    
    internal func applyGlobalState() {
        if NSLayoutConstraint.isExecutingPriorityConstraintsBlock() {
            priority = NSLayoutConstraint.currentGlobalConstraintPriority().layoutPriority
        }
        
        if let globalIdentifier = NSLayoutConstraint.currentGlobalConstraintIdentifier() {
            autoIdentify(globalIdentifier)
        }
    }
}

// MARK: - Set Priority For Constraints -

public extension NSLayoutConstraint {
    
    private static var globalConstraintPriorities = [SLPriority]()
    
    internal class func currentGlobalConstraintPriority() -> SLPriority {
        if let priority = globalConstraintPriorities.last {
            return priority
        }
        
        return .Required
    }
    
    internal class func isExecutingPriorityConstraintsBlock() -> Bool {
        return globalConstraintPriorities.count > 0
    }
    
    public class func autoSetPriority(priority: SLPriority, block: SLConstraintsBlock) {
        globalConstraintPriorities.append(priority)
        
        block()
        
        globalConstraintPriorities.removeLast()
    }
    
    public func autoPriority(priority: SLPriority) -> NSLayoutConstraint {
        self.priority = priority.layoutPriority
        
        return self
    }
}

// MARK: - Identify Constraints -

public extension NSLayoutConstraint {
    
    private static var globalIdentifiers = [String]()
    
    private class func currentGlobalConstraintIdentifier() -> String? {
        if let id = globalIdentifiers.last {
            return id
        }
        
        return nil
    }
    
    public class func autoSetIdentifier(identifier: String, forConstraints block: SLConstraintsBlock) {
        globalIdentifiers.append(identifier)
        
        block()
        
        globalIdentifiers.removeLast()
    }
    
    public func autoIdentify(identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        
        return self
    }
}

public extension NSLayoutConstraint {
    
    private static let layoutRelationDiscription: [NSLayoutRelation: String] = {
        return [
            NSLayoutRelation.Equal: "==",
            NSLayoutRelation.GreaterThanOrEqual: ">=",
            NSLayoutRelation.LessThanOrEqual: "<="
        ]
    }()
    
    private static let layoutAttributeDiscription: [NSLayoutAttribute: String] = {
        var dict = [
            NSLayoutAttribute.Top: "top",
            NSLayoutAttribute.Left: "left",
            NSLayoutAttribute.Bottom: "bottom",
            NSLayoutAttribute.Right: "right",
            NSLayoutAttribute.Leading: "leading",
            NSLayoutAttribute.Trailing: "trailing",
            NSLayoutAttribute.Width: "width",
            NSLayoutAttribute.Height: "height",
            NSLayoutAttribute.CenterX: "centerX",
            NSLayoutAttribute.CenterY: "centerY",
            NSLayoutAttribute.Baseline: "baseline"
        ]
        
        #if os(iOS) || os(tvOS)
            dict[NSLayoutAttribute.FirstBaseline] = "firstBaseline"
            dict[NSLayoutAttribute.LeftMargin] = "leftMargin"
            dict[NSLayoutAttribute.RightMargin] = "rightMargin"
            dict[NSLayoutAttribute.TopMargin] = "topMargin"
            dict[NSLayoutAttribute.BottomMargin] = "bottomMargin"
            dict[NSLayoutAttribute.LeadingMargin] = "leadingMargin"
            dict[NSLayoutAttribute.TrailingMargin] = "trailingMargin"
            dict[NSLayoutAttribute.CenterXWithinMargins] = "centerXWithinMargins"
            dict[NSLayoutAttribute.CenterYWithinMargins] = "centerYWithinMargins"
        #endif
        
        return dict
    }()
    
    private static let layoutPriorityDescription: [SLLayoutPriority: String] = {
        var dict = [SLLayoutPriority: String]()
        
        dict[SLLayoutPriorityRequired] = "required"
        dict[SLLayoutPriorityDefaultHigh] = "high"
        dict[SLLayoutPriorityDefaultLow] = "low"
        dict[SLLayoutPriorityFittingSizeLevel] = "fitting size"
        dict[SLLayoutPriorityFittingSizeCompression] = "fitting size compression"
        dict[SLLayoutPriorityDragThatCanResizeWindow] = "drag can resize window"
        dict[SLLayoutPriorityDragThatCannotResizeWindow] = "drag cannot resize window"
        dict[SLLayoutPriorityWindowSizeStayPut] = "window size stay put"
        
        return dict
    }()
    
    class func descriptionForObject(obj: AnyObject) -> String {
        if let constraint = obj as? NSLayoutConstraint, let identifier = constraint.identifier {
            return "\(constraint.dynamicType):\(identifier)"
        }
        
//        let pointerDescription = NSString(format: "%p", ObjectIdentifier(obj).uintValue)
        
        return "\(obj.dynamicType)"
    }
    
    override var description: String {
        var descriptionString = "<"
        
        descriptionString.appendContentsOf(NSLayoutConstraint.descriptionForObject(self))
        
        descriptionString.appendContentsOf(" \(NSLayoutConstraint.descriptionForObject(firstItem))")
        
        if let firstAttributeString = NSLayoutConstraint.layoutAttributeDiscription[firstAttribute] where firstAttribute != .NotAnAttribute {
            descriptionString.appendContentsOf(".\(firstAttributeString)")
        }
        
        if let relationString = NSLayoutConstraint.layoutRelationDiscription[relation] {
            descriptionString.appendContentsOf(" \(relationString)")
        }
        
        if let secondItem = secondItem {
            descriptionString.appendContentsOf(" \(NSLayoutConstraint.descriptionForObject(secondItem))")
        }
        
        if let secondAttributeString = NSLayoutConstraint.layoutAttributeDiscription[secondAttribute] where secondAttribute != .NotAnAttribute {
            descriptionString.appendContentsOf(".\(secondAttributeString)")
        }
        
        if multiplier != 1 {
            descriptionString.appendContentsOf(" * \(multiplier)")
        }
        
        if secondAttribute == .NotAnAttribute {
            descriptionString.appendContentsOf(" \(constant)")
        } else {
            let constantString = constant < 0 ? "-" : "+"
            
            descriptionString.appendContentsOf(" \(constantString) \(abs(constant))")
        }
        
        if priority != SLLayoutPriorityRequired {
            let priorityString = NSLayoutConstraint.layoutPriorityDescription[priority] ?? String(priority)
            
            descriptionString.appendContentsOf(" ^\(priorityString)")
        }
        
        descriptionString.appendContentsOf(">")
        
        return descriptionString
    }
}

// MARK: - Convenient Functions for Layout Constraint Arrays -

public extension CollectionType where Generator.Element: NSLayoutConstraint {
    
    public func autoInstall() {
        for object in self {
            object.applyGlobalState()
        }
        
        if NSLayoutConstraint.preventAutomaticConstraintInstallation() {
            let group = NSLayoutConstraint.currentConstraintsGroup()
            
            group!.constraints.appendContentsOf(self as! LayoutConstraintsArray)
        } else {
            NSLayoutConstraint.activateConstraints(self as! LayoutConstraintsArray)
        }
    }
    
    public func autoIdentify(identifier: String) {
        for constraint in self {
            constraint.autoIdentify(identifier)
        }
    }
    
    public func autoSetPriority(priority: SLPriority) {
        for constraint in self {
            constraint.autoPriority(priority)
        }
    }
    
    public func autoRemove() {
        NSLayoutConstraint.deactivateConstraints(self as! LayoutConstraintsArray)
    }
}

func ==(lhs: NSLayoutConstraint, rhs: NSLayoutConstraint) -> Bool {
    if lhs.firstItem !== rhs.firstItem {
        return false
    }
    
    if lhs.secondItem !== rhs.secondItem {
        return false
    }
    
    if lhs.firstAttribute != rhs.firstAttribute {
        return false
    }
    
    if lhs.secondAttribute != rhs.secondAttribute {
        return false
    }
    
    if lhs.relation != rhs.relation {
        return false
    }
    
    if lhs.priority != rhs.priority {
        return false
    }
    
    if lhs.multiplier != rhs.multiplier {
        return false
    }
    
    return true
}
