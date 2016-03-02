//
//  SAView.swift
//  SwiftLayout
//
//  Created by Juan Alvarez on 2/2/16.
//  Copyright © 2016 Juan Alvarez. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import Cocoa
#endif

// MARK: Factory and Initializer Methods -

public extension SAView {
    
    public class func newAutoLayoutView() -> Self {
        let view = self.init()
        view.configureForAutoLayout()
        
        return view
    }
    
    public func configureForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        
        return self
    }
}

// MARK: - Pin Edges to Superview -

public extension SAView {
    
    public func autoPinSidesToSuperViewEdges(insets: SAEdgeInsets = SAEdgeInsetsZero) -> LayoutConstraintsArray {
        return autoPinEdgesToSuperViewEdges([.Leading, .Trailing], insets: insets)
    }
    
    public func autoPinTopAndBottomToSuperViewEdges(insets: SAEdgeInsets = SAEdgeInsetsZero) -> LayoutConstraintsArray {
        return autoPinEdgesToSuperViewEdges([.Top, .Bottom], insets: insets)
    }
    
    public func autoPinEdgesToSuperViewEdges(edges: [SAEdge] = [.Top, .Bottom, .Leading, .Trailing], insets: SAEdgeInsets = SAEdgeInsetsZero) -> LayoutConstraintsArray {
        guard edges.count > 0 else {
            fatalError("You need at least edge for autoPinEdgesToSuperViewEdges()")
        }
        
        var constraints = LayoutConstraintsArray()
        
        if edges.contains(.Top) {
            constraints.append(autoPinEdgeToSuperViewEdge(.Top, inset: insets.top))
        }
        
        if edges.contains(.Leading) || edges.contains(.Left) {
            constraints.append(autoPinEdgeToSuperViewEdge(.Leading, inset: insets.left))
        }
        
        if edges.contains(.Bottom) {
            constraints.append(autoPinEdgeToSuperViewEdge(.Bottom, inset: insets.bottom))
        }
        
        if edges.contains(.Trailing) || edges.contains(.Right) {
            constraints.append(autoPinEdgeToSuperViewEdge(.Trailing, inset: insets.right))
        }
        
        return constraints
    }
    
    #if os(iOS) || os(tvOS)
    public func autoPinEdgesToSuperviewMargins(edges: [SAEdge] = [.Top, .Bottom, .Leading, .Trailing]) -> LayoutConstraintsArray {
        guard edges.count > 0 else {
            fatalError("You need at least edge for autoPinEdgesToSuperviewMargins()")
        }
        
        var constraints = LayoutConstraintsArray()
        
        if edges.contains(.Top) {
            constraints.append(autoPinEdgeToSuperviewMarginEdge(.Top))
        }
        
        if edges.contains(.Leading) || edges.contains(.Left) {
            constraints.append(autoPinEdgeToSuperviewMarginEdge(.Leading))
        }
        
        if edges.contains(.Bottom) {
            constraints.append(autoPinEdgeToSuperviewMarginEdge(.Bottom))
        }
        
        if edges.contains(.Trailing) {
            constraints.append(autoPinEdgeToSuperviewMarginEdge(.Trailing))
        }
        
        return constraints
    }
    #endif
    
    public func autoPinEdgeToSuperViewEdge(
        edge: SAEdge,
        var inset: CGFloat = 0.0,
        var relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint
    {
        let sView = checkForSuperView()
        
        translatesAutoresizingMaskIntoConstraints = true
        
        switch edge {
        case .Bottom, .Right, .Trailing:
            inset = -inset
            
            if relation == .LessThanOrEqual {
                relation = .GreaterThanOrEqual
            } else if relation == .GreaterThanOrEqual {
                relation = .LessThanOrEqual
            }
        default:
            break
        }
        
        return autoPinEdge(edge, toEdge: edge, ofView: sView, withOffset: inset, relation: relation)
    }
    
    #if os(iOS) || os(tvOS)
    public func autoPinEdgeToSuperviewMarginEdge(edge: SAEdge, var relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        let sView = checkForSuperView()
        
        switch edge {
        case .Bottom, .Right, .Trailing:
            // the bottom, right, and trailing relations are inverted
            if relation == .LessThanOrEqual {
                relation = .GreaterThanOrEqual
            } else if relation == .GreaterThanOrEqual {
                relation = .LessThanOrEqual
            }
        default:
            break
        }
        
        return autoConstrain(edge.slAttribute, toAttribute: edge.margin.slAttribute, ofView: sView, withOffset: 0.0, relation: relation)
    }
    #endif
}

// MARK: - Align Axes -

public extension SAView {
    
    public func autoAlignAxis(axis: SAAxis, toSameAxisOfView otherView: SAView, withOffset offset: CGFloat = 0.0) -> NSLayoutConstraint {
        return autoConstrain(axis.slAttribute, toAttribute: axis.slAttribute, ofView: otherView, withOffset: offset)
    }
    
    public func autoAlignAxisWithMultiplier(axis: SAAxis, toSameAxisOfView otherView: SAView, multiplier: CGFloat) -> NSLayoutConstraint {
        return autoConstrainWithMultiplier(axis.slAttribute, toAttribute: axis.slAttribute, ofView: otherView, withMultiplier: multiplier)
    }
}

// MARK: - Match/Set Dimensions -

public extension SAView {
    
    public func autoMatchSameDimension(dimension: SADimension, ofView otherView: SAView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoMatchDimension(dimension, toDimension: dimension, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoMatchDimension(
        dimension: SADimension,
        toDimension: SADimension,
        ofView otherView: SAView,
        withOffset offset: CGFloat = 0.0,
        relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint
    {
        return autoConstrain(dimension.slAttribute, toAttribute: toDimension.slAttribute, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoSetDimensionsToSize(size: CGSize) -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.append(autoSetDimension(.Width, toSize: size.width))
        constraints.append(autoSetDimension(.Height, toSize: size.height))
        
        return constraints
    }
    
    public func autoSetDimension(dimension: SADimension, toSize: CGFloat, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: dimension.slAttribute.layoutAttribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: toSize)
        
        constraint.autoInstall()
        
        return constraint
    }
}

// MARK: - Center in Superview -

public extension SAView {
    
    public func autoCenterInSuperView() -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.append(autoAlignAxisToSuperviewAxis(.Horizontal))
        constraints.append(autoAlignAxisToSuperviewAxis(.Vertical))
        
        return constraints
    }
    
    #if os(iOS) || os(tvOS)
    public func autoCenterInSuperViewMargins() -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.append(autoAlignAxisToSuperviewMarginAxis(.Horizontal))
        constraints.append(autoAlignAxisToSuperviewMarginAxis(.Vertical))
        
        return constraints
    }
    #endif
    
    public func autoAlignAxisToSuperviewAxis(axis: SAAxis) -> NSLayoutConstraint {
        let sView = checkForSuperView()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        return autoConstrain(axis.slAttribute, toAttribute: axis.slAttribute, ofView: sView)
    }
    
    #if os(iOS) || os(tvOS)
    public func autoAlignAxisToSuperviewMarginAxis(axis: SAAxis) -> NSLayoutConstraint {
        let sView = checkForSuperView()
        
        translatesAutoresizingMaskIntoConstraints = true
        
        return autoConstrain(axis.slAttribute, toAttribute: axis.slMarginAttribute, ofView: sView)
    }
    #endif
}

// MARK: - Pin Edges -

public extension SAView {
    
    public func autoPinTopEdgeToBottomEdge(ofView otherView: SAView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoPinEdge(.Top, toEdge: .Bottom, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoPinLeadingEdgeToTrailingEdge(ofView otherView: SAView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoPinEdge(.Leading, toEdge: .Trailing, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoPinEdge(
        edge: SAEdge,
        toEdge: SAEdge,
        ofView otherView: SAView,
        withOffset offset: CGFloat = 0.0,
        relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint
    {
        return autoConstrain(edge.slAttribute, toAttribute: toEdge.slAttribute, ofView: otherView, withOffset: offset, relation: relation)
    }
}

// MARK: - Constrain Any Attributes -

public extension SAView {
    
    public func autoConstrain(
        attribute: SAAttribute,
        toAttribute: SAAttribute, 
        ofView otherView: SAView,
        withOffset offset: CGFloat = 0.0,
        relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let layoutAttribute = attribute.layoutAttribute
        let toLayoutAttribute = toAttribute.layoutAttribute
        
        let constraint = NSLayoutConstraint(item: self, attribute: layoutAttribute, relatedBy: relation, toItem: otherView, attribute: toLayoutAttribute, multiplier: 1.0, constant: offset)
        
        constraint.autoInstall()
        
        return constraint
    }
    
    public func autoConstrainWithMultiplier(
        attribute: SAAttribute,
        toAttribute: SAAttribute,
        ofView otherView: SAView,
        withMultiplier multiplier: CGFloat,
        relation: NSLayoutRelation = .Equal)  -> NSLayoutConstraint
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let layoutAttribute = attribute.layoutAttribute
        let toLayoutAttribute = toAttribute.layoutAttribute
        
        let constraint = NSLayoutConstraint(item: self, attribute: layoutAttribute, relatedBy: relation, toItem: otherView, attribute: toLayoutAttribute, multiplier: multiplier, constant: 0.0)
        
        constraint.autoInstall()
        
        return constraint
    }
    
    public func autoAlign(alignment alignment: SAAlignment, toView: SAView, forAxis axis: SAAxis) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        
        #if os(iOS) || os(tvOS)
            switch alignment {
            case .Vertical:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeVertical.")
                constraint = autoAlignAxis(.Vertical, toSameAxisOfView: toView)
            case .Horizontal:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeHorizontal.")
                constraint = autoAlignAxis(.Horizontal, toSameAxisOfView: toView)
            case .Baseline:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeBaseline.")
                constraint = autoAlignAxis(.Baseline, toSameAxisOfView: toView)
            case .FirstBaseline:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeFirstBaseline.")
                constraint = autoAlignAxis(.FirstBaseline, toSameAxisOfView: toView)
            case .Top:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeTop.")
                constraint = autoPinEdge(.Top, toEdge: .Top, ofView: toView)
            case .Left:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeLeft.")
                constraint = autoPinEdge(.Left, toEdge: .Left, ofView: toView)
            case .Bottom:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeBottom.")
                constraint = autoPinEdge(.Bottom, toEdge: .Bottom, ofView: toView)
            case .Right:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeRight.")
                constraint = autoPinEdge(.Right, toEdge: .Right, ofView: toView)
            case .Leading:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeLeading.")
                constraint = autoPinEdge(.Leading, toEdge: .Leading, ofView: toView)
            case .Trailing:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeTrailing.")
                constraint = autoPinEdge(.Trailing, toEdge: .Trailing, ofView: toView)
            }
        #else
            switch alignment {
            case .Vertical:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeVertical.")
                constraint = autoAlignAxis(.Vertical, toSameAxisOfView: toView)
            case .Horizontal:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeHorizontal.")
                constraint = autoAlignAxis(.Horizontal, toSameAxisOfView: toView)
            case .Baseline:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeBaseline.")
                constraint = autoAlignAxis(.Baseline, toSameAxisOfView: toView)
            case .Top:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeTop.")
                constraint = autoPinEdge(.Top, toEdge: .Top, ofView: toView)
            case .Left:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeLeft.")
                constraint = autoPinEdge(.Left, toEdge: .Left, ofView: toView)
            case .Bottom:
                assert(axis != .Vertical, "Cannot align views that are distributed vertically with SAAttributeBottom.")
                constraint = autoPinEdge(.Bottom, toEdge: .Bottom, ofView: toView)
            case .Right:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeRight.")
                constraint = autoPinEdge(.Right, toEdge: .Right, ofView: toView)
            case .Leading:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeLeading.")
                constraint = autoPinEdge(.Leading, toEdge: .Leading, ofView: toView)
            case .Trailing:
                assert(axis == .Vertical, "Cannot align views that are distributed horizontally with SAAttributeTrailing.")
                constraint = autoPinEdge(.Trailing, toEdge: .Trailing, ofView: toView)
            }
        #endif
        
        return constraint
    }
}

// MARK: - Pin to Layout Guides -

#if os(iOS)
public extension SAView {
    
    public func autoPinToTopLayoutGuideOfViewController(viewController: UIViewController, withInset inset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: relation, toItem: viewController.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: inset)
        
        viewController.view.sl_addConstraint(constraint) // Can't use autoInstall because the layout guide is not a view
        
        return constraint
    }
    
    public func autoPinToBottomLayoutGuideOfViewController(viewController: UIViewController, var withInset inset: CGFloat = 0.0, var relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        // The bottom inset (and relation, if an inequality) is inverted to become an offset
        inset = -inset
        
        if relation == .LessThanOrEqual {
            relation = .GreaterThanOrEqual
        } else if relation == .GreaterThanOrEqual {
            relation = .LessThanOrEqual
        }
        
        translatesAutoresizingMaskIntoConstraints = true
        
        let constraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: relation, toItem: viewController.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: inset)
        
        viewController.view.sl_addConstraint(constraint) // Can't use autoInstall because the layout guide is not a view
        
        return constraint
    }
}
#endif

// MARK: - Install/Update Constraints on SAView -

public extension SAView {
    
    public func autoInstallConstraints(identifier: String? = nil, block: SAViewConstraintsBlock) {
        let constraints = NSLayoutConstraint.autoCreateConstrainsWithoutInstalling { () -> Void in
            block(view: self)
        }
        
        if let identifier = identifier {
            constraints.autoIdentify(identifier)
        }
        
        constraints.autoInstall()
    }
    
    public func autoUpdateConstraints(identifier: String? = nil, block: SAViewConstraintsBlock) {
        let newLayoutConstraints = NSLayoutConstraint.autoCreateConstrainsWithoutInstalling { () -> Void in
            block(view: self)
        }
        
        let existingConstraints = constraints
        
        // array that will contain only new layout constraints to keep
        var newLayoutConstraintsToKeep = LayoutConstraintsArray()
        
        for layoutConstraint in newLayoutConstraints {
            // layout constraint that should be updated
            var updateLayoutConstraint: NSLayoutConstraint?
            
            // loop through existing and check for match
            for existingConstraint in existingConstraints where existingConstraint == layoutConstraint {
                updateLayoutConstraint = existingConstraint
                break
            }
            
            // if we have existing one lets just update the constant
            if let update = updateLayoutConstraint {
                update.constant = layoutConstraint.constant
                
                if let identifier = identifier {
                    update.autoIdentify(identifier)
                }
            } else {
                // otherwise add this layout constraint to new keep list
                newLayoutConstraintsToKeep.append(layoutConstraint)
            }
        }
        
        if let identifier = identifier {
            newLayoutConstraintsToKeep.autoIdentify(identifier)
        }

        newLayoutConstraintsToKeep.autoInstall()
    }
}

// MARK: - Set Content Compression Resistance & Hugging -

public extension SAView {
    
    func autoSetContentCompressionResistancePriorityFor(axis: SAAxis) {
        let isExecuting = NSLayoutConstraint.isExecutingPriorityConstraintsBlock()
        
        guard isExecuting else {
            assert(isExecuting, "\(__FUNCTION__) should only be called from within the block passed into the method +autoSetPriority:forConstraints:()")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let priority = NSLayoutConstraint.currentGlobalConstraintPriority().layoutPriority
        
        #if os(iOS)
            setContentCompressionResistancePriority(priority, forAxis: axis.constraintAxis)
        #else
            setContentCompressionResistancePriority(priority, forOrientation: axis.constraintAxis)
        #endif
    }
    
    func autoSetContentHuggingPriorityFor(axis: SAAxis) {
        let isExecuting = NSLayoutConstraint.isExecutingPriorityConstraintsBlock()
        
        guard isExecuting else {
            assert(isExecuting, "\(__FUNCTION__) should only be called from within the block passed into the method +autoSetPriority:forConstraints:()")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let priority = NSLayoutConstraint.currentGlobalConstraintPriority().layoutPriority
        
        #if os(iOS)
            setContentHuggingPriority(priority, forAxis: axis.constraintAxis)
        #else
            setContentHuggingPriority(priority, forOrientation: axis.constraintAxis)
        #endif
    }
}

// MARK: - Internal Methods -

private extension SAView {
    
    func checkForSuperView() -> SAView {
        guard let sView = superview else {
            fatalError("View's superview must not be nil.\nView: \(self)")
        }
        
        return sView
    }
    
    func sl_addConstraint(constraint: NSLayoutConstraint) {
        constraint.applyGlobalState()
        
        if NSLayoutConstraint.preventAutomaticConstraintInstallation() {
            let group = NSLayoutConstraint.currentConstraintsGroup()!
            group.constraints.append(constraint)
            
            NSLayoutConstraint.arraysOfCreatedConstraints.append(group)
        } else {
            addConstraint(constraint)
        }
    }
}
