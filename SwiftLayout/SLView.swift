//
//  SLView.swift
//  SwiftLayout
//
//  Created by Juan Alvarez on 2/2/16.
//  Copyright © 2016 Juan Alvarez. All rights reserved.
//

import UIKit

public typealias LayoutConstraintsArray = [NSLayoutConstraint]
public typealias SLConstraintsBlock = () -> Void
public typealias SLViewConstraintsBlock = (view: UIView) -> Void

public enum SLAttribute {
    case Left
    case Right
    case Top
    case Bottom
    
    case Leading
    case Trailing
    
    case Width
    case Height
    
    case AxisVertical
    case AxisHorizontal
    case AxisBaseline
    case AxisLastBaseline
    case AxisFirstBaseline
    
    case MarginLeft
    case MarginRight
    case MarginTop
    case MarginBottom
    case MarginLeading
    case MarginTrailing
    case MarginAxisVertical
    case MarginAxisHorizontal
    
    var layoutAttribute: NSLayoutAttribute {
        switch self {
        case .Left:
            return NSLayoutAttribute.Left
        case .Right:
            return NSLayoutAttribute.Right
        case .Top:
            return NSLayoutAttribute.Top
        case .Bottom:
            return NSLayoutAttribute.Bottom
        case .Leading:
            return NSLayoutAttribute.Leading
        case .Trailing:
            return NSLayoutAttribute.Trailing
        case .Width:
            return NSLayoutAttribute.Width
        case .Height:
            return NSLayoutAttribute.Height
        case .AxisVertical:
            return NSLayoutAttribute.CenterX
        case .AxisHorizontal:
            return NSLayoutAttribute.CenterY
        case .AxisBaseline:
            return NSLayoutAttribute.Baseline
        case .AxisFirstBaseline:
            return NSLayoutAttribute.FirstBaseline
        case .AxisLastBaseline:
            return NSLayoutAttribute.LastBaseline
        case .MarginLeft:
            return NSLayoutAttribute.LeftMargin
        case .MarginRight:
            return NSLayoutAttribute.RightMargin
        case .MarginTop:
            return NSLayoutAttribute.TopMargin
        case .MarginBottom:
            return NSLayoutAttribute.BottomMargin
        case .MarginLeading:
            return NSLayoutAttribute.LeadingMargin
        case .MarginTrailing:
            return NSLayoutAttribute.TrailingMargin
        case .MarginAxisVertical:
            return NSLayoutAttribute.CenterXWithinMargins
        case .MarginAxisHorizontal:
            return NSLayoutAttribute.CenterYWithinMargins
        }
    }
}

public enum SLAxis {
    case Vertical
    case Horizontal
    case Baseline
    case LastBaseline
    case FirstBaseline
    
    var slAttribute: SLAttribute {
        switch self {
        case .Vertical:
            return .AxisVertical
        case .Horizontal:
            return .AxisHorizontal
        case .Baseline:
            return .AxisBaseline
        case .LastBaseline:
            return .AxisLastBaseline
        case .FirstBaseline:
            return .AxisFirstBaseline
        }
    }
    
    var slMarginAttribute: SLAttribute {
        switch self {
        case .Vertical:
            return .MarginAxisVertical
        case .Horizontal:
            return .MarginAxisHorizontal
        case .Baseline, .LastBaseline, .FirstBaseline:
            fatalError("The baseline axis attributes do not have corresponding margin axis attributes")
        }
    }
}

public enum SLEdge {
    case Left
    case Right
    case Top
    case Bottom
    case Leading
    case Trailing
    
    var slAttribute: SLAttribute {
        switch self {
        case .Left:
            return .Left
        case .Right:
            return .Right
        case .Top:
            return .Top
        case .Bottom:
            return .Bottom
        case .Leading:
            return .Leading
        case .Trailing:
            return .Trailing
        }
    }
    
    var margin: SLMargin {
        switch self {
        case .Left:
            return .Left
        case .Right:
            return .Right
        case .Top:
            return .Top
        case .Bottom:
            return .Bottom
        case .Leading:
            return .Leading
        case .Trailing:
            return .Trailing
        }
    }
}

public enum SLMargin {
    case Left
    case Right
    case Top
    case Bottom
    case Leading
    case Trailing
    
    var slAttribute: SLAttribute {
        switch self {
        case .Left:
            return .MarginLeft
        case .Right:
            return .MarginRight
        case .Top:
            return .MarginTop
        case .Bottom:
            return .MarginBottom
        case .Leading:
            return .MarginLeading
        case .Trailing:
            return .MarginTrailing
        }
    }
}

public enum SLDimension {
    case Width
    case Height
    
    var slAttribute: SLAttribute {
        switch self {
        case .Width:
            return .Width
        case .Height:
            return .Height
        }
    }
}

private extension UIView {
    
    func checkForSuperView() -> UIView {
        guard let sView = superview else {
            fatalError("View's superview must not be nil.\nView: \(self)")
        }
        
        return sView
    }
    
    func sl_addConstraint(constraint: NSLayoutConstraint) {
        addConstraint(constraint)
    }
}

// MARK: - Factory and Initializer Methods -

public extension UIView {
    
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

public extension UIView {
    
    public func autoPinSidesToSuperViewEdges(insets: UIEdgeInsets = UIEdgeInsetsZero) -> LayoutConstraintsArray {
        return autoPinEdgesToSuperViewEdges([.Leading, .Trailing], insets: insets)
    }
    
    public func autoPinTopAndBottomToSuperViewEdges(insets: UIEdgeInsets = UIEdgeInsetsZero) -> LayoutConstraintsArray {
        return autoPinEdgesToSuperViewEdges([.Top, .Bottom], insets: insets)
    }
    
    public func autoPinEdgesToSuperViewEdges(edges: [SLEdge] = [.Top, .Bottom, .Leading, .Trailing], insets: UIEdgeInsets = UIEdgeInsetsZero) -> LayoutConstraintsArray {
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
    
    public func autoPinEdgesToSuperviewMargins(edges: [SLEdge] = [.Top, .Bottom, .Leading, .Trailing]) -> LayoutConstraintsArray {
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
    
    public func autoPinEdgeToSuperViewEdge(
        edge: SLEdge,
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
    
    public func autoPinEdgeToSuperviewMarginEdge(edge: SLEdge, var relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
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
}

// MARK: - Align Axes -

public extension UIView {
    
    public func autoAlignAxis(axis: SLAxis, toSameAxisOfView otherView: UIView, withOffset offset: CGFloat = 0.0) -> NSLayoutConstraint {
        return autoConstrain(axis.slAttribute, toAttribute: axis.slAttribute, ofView: otherView, withOffset: offset)
    }
    
    public func autoAlignAxisWithMultiplier(axis: SLAxis, toSameAxisOfView otherView: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        return autoConstrainWithMultiplier(axis.slAttribute, toAttribute: axis.slAttribute, ofView: otherView, withMultiplier: multiplier)
    }
}

// MARK: - Match/Set Dimensions -

public extension UIView {
    
    public func autoMatchSameDimension(dimension: SLDimension, ofView otherView: UIView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoMatchDimension(dimension, toDimension: dimension, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoMatchDimension(
        dimension: SLDimension,
        toDimension: SLDimension,
        ofView otherView: UIView,
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
    
    public func autoSetDimension(dimension: SLDimension, toSize: CGFloat, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: dimension.slAttribute.layoutAttribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: toSize)
        
        constraint.autoInstall()
        
        return constraint
    }
}

// MARK: - Center in Superview -

public extension UIView {
    
    public func autoCenterInSuperView() -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.append(autoAlignAxisToSuperviewAxis(.Horizontal))
        constraints.append(autoAlignAxisToSuperviewAxis(.Vertical))
        
        return constraints
    }
    
    public func autoCenterInSuperViewMargins() -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.append(autoAlignAxisToSuperviewMarginAxis(.Horizontal))
        constraints.append(autoAlignAxisToSuperviewMarginAxis(.Vertical))
        
        return constraints
    }
    
    public func autoAlignAxisToSuperviewAxis(axis: SLAxis) -> NSLayoutConstraint {
        let sView = checkForSuperView()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        return autoConstrain(axis.slAttribute, toAttribute: axis.slAttribute, ofView: sView)
    }
    
    public func autoAlignAxisToSuperviewMarginAxis(axis: SLAxis) -> NSLayoutConstraint {
        let sView = checkForSuperView()
        
        translatesAutoresizingMaskIntoConstraints = true
        
        return autoConstrain(axis.slAttribute, toAttribute: axis.slMarginAttribute, ofView: sView)
    }
}

// MARK: - Pin Edges -

public extension UIView {
    
    public func autoPinTopEdgeToBottomEdge(ofView otherView: UIView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoPinEdge(.Top, toEdge: .Bottom, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoPinLeadingEdgeToTrailingEdge(ofView otherView: UIView, withOffset offset: CGFloat = 0.0, relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        return autoPinEdge(.Leading, toEdge: .Trailing, ofView: otherView, withOffset: offset, relation: relation)
    }
    
    public func autoPinEdge(
        edge: SLEdge,
        toEdge: SLEdge,
        ofView otherView: UIView,
        withOffset offset: CGFloat = 0.0,
        relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint
    {
        return autoConstrain(edge.slAttribute, toAttribute: toEdge.slAttribute, ofView: otherView, withOffset: offset, relation: relation)
    }
}

// MARK: - Constrain Any Attributes -

public extension UIView {
    
    public func autoConstrain(
        attribute: SLAttribute,
        toAttribute: SLAttribute, 
        ofView otherView: UIView,
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
        attribute: SLAttribute,
        toAttribute: SLAttribute,
        ofView otherView: UIView,
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
}

#if os(iOS)
    public extension UIView {
        
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

// MARK: - Install/Update Constraints on UIView -

public extension UIView {
    
    public func autoInstallConstraints(identifier: String? = nil, block: SLViewConstraintsBlock) {
        let constraints = NSLayoutConstraint.autoCreateConstrainsWithoutInstalling { () -> Void in
            block(view: self)
        }
        
        if let identifier = identifier {
            NSLayoutConstraint.autoIdentify(identifier, forConstraints: constraints)
        }
        
        NSLayoutConstraint.autoInstallConstraints(constraints)
    }
    
    public func autoUpdateConstraints(identifier: String? = nil, block: SLViewConstraintsBlock) {
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
            NSLayoutConstraint.autoIdentify(identifier, forConstraints: newLayoutConstraintsToKeep)
        }

        NSLayoutConstraint.autoInstallConstraints(newLayoutConstraintsToKeep)
    }
}

// MARK: - Batch Constraint Creation -

public extension NSLayoutConstraint {
    
    private class ConstraintsGroup {
        var constraints: LayoutConstraintsArray
        var identifier: String?
        var priority: UILayoutPriority
        
        init(constraints: LayoutConstraintsArray, identifier: String? = nil, priority: UILayoutPriority = UILayoutPriorityRequired) {
            self.constraints = constraints
            self.identifier = identifier
            self.priority = priority
        }
    }
    
    private static var arraysOfCreatedConstraints = [ConstraintsGroup]()
    private static var isInstallingConstraints = false
    
    private class func currentConstraintsGroup() -> ConstraintsGroup? {
        return arraysOfCreatedConstraints.last
    }
    
    private class func preventAutomaticConstraintInstallation() -> Bool {
        return !isInstallingConstraints && arraysOfCreatedConstraints.count > 0
    }
    
    public class func autoCreateAndInstallConstraints(block: SLConstraintsBlock) -> LayoutConstraintsArray {
        let createdConstraints = autoCreateConstrainsWithoutInstalling(block)
        
        isInstallingConstraints = true
        
        autoInstallConstraints(createdConstraints)
        
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
        applyGlobalStateToConstraint()
        
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
    
    private func applyGlobalStateToConstraint() {
        if NSLayoutConstraint.isExecutingPriorityConstraintsBlock() {
            priority = NSLayoutConstraint.currentGlobalConstraintPriority()
        }
        
        if let globalIdentifier = NSLayoutConstraint.currentGlobalConstraintIdentifier() {
            autoIdentify(globalIdentifier)
        }
    }
}

// MARK: - Set Priority For Constraints -

public extension NSLayoutConstraint {
    
    private static var globalConstraintPriorities = [UILayoutPriority]()
    
    private class func currentGlobalConstraintPriority() -> UILayoutPriority {
        if let priority = globalConstraintPriorities.last {
            return priority
        }
        
        return UILayoutPriorityRequired
    }
    
    private class func isExecutingPriorityConstraintsBlock() -> Bool {
        return globalConstraintPriorities.count > 0
    }
    
    public class func autoSetPriority(priority: UILayoutPriority, block: SLConstraintsBlock) {
        globalConstraintPriorities.append(priority)
        
        block()
        
        globalConstraintPriorities.removeLast()
    }
    
    public func autoPriority(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        
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

// MARK: - Convenient Functions for Layout Constraint Arrays -

public extension NSLayoutConstraint {
    
    public class func autoInstallConstraints(constraints: LayoutConstraintsArray) {
        for object in constraints {
            object.applyGlobalStateToConstraint()
        }
        
        if NSLayoutConstraint.preventAutomaticConstraintInstallation() {
            let group = NSLayoutConstraint.currentConstraintsGroup()
            
            group!.constraints.appendContentsOf(constraints)
        } else {
            NSLayoutConstraint.activateConstraints(constraints)
        }
    }
    
    public class func autoRemoveConstraints(constraints: LayoutConstraintsArray) {
        NSLayoutConstraint.deactivateConstraints(constraints)
    }
    
    public class func autoIdentify(identifier: String, forConstraints constraints: LayoutConstraintsArray) {
        for object in constraints {
            object.autoIdentify(identifier)
        }
    }
    
    public class func autoSetPriority(priority: UILayoutPriority, forConstraints constraints: LayoutConstraintsArray) {
        for object in constraints {
            object.autoPriority(priority)
        }
    }
}

public extension CollectionType where Generator.Element: UIView {
    
    public func autoAlignViewsToEdge(edge: SLEdge) -> LayoutConstraintsArray {
        guard self.count >= 2 else {
            fatalError("This array must contain at least 2 views")
        }
        
        var constraints = LayoutConstraintsArray()
        var previousView: UIView?
        
        for view in self {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previousView = previousView {
                constraints.append(view.autoPinEdge(edge, toEdge: edge, ofView: previousView))
            }
            
            previousView = view
        }
        
        return constraints
    }
    
    public func autoAlignViewsToAxis(axis: SLAxis) -> LayoutConstraintsArray {
        guard self.count >= 2 else {
            fatalError("This array must contain at least 2 views")
        }
        
        var constraints = LayoutConstraintsArray()
        var previousView: UIView?
        
        for view in self {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previousView = previousView {
                constraints.append(view.autoAlignAxis(axis, toSameAxisOfView: previousView))
            }
            
            previousView = view
        }
        
        return constraints
    }
    
    public func autoMatchViewsToDimension(dimension: SLDimension) -> LayoutConstraintsArray {
        guard self.count >= 2 else {
            fatalError("This array must contain at least 2 views")
        }
        
        var constraints = LayoutConstraintsArray()
        var previousView: UIView?
        
        for view in self {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previousView = previousView {
                constraints.append(view.autoMatchDimension(dimension, toDimension: dimension, ofView: previousView))
            }
            
            previousView = view
        }
        
        return constraints
    }
    
    public func autoSetViewsDimension(dimension: SLDimension, toSize: CGFloat) -> LayoutConstraintsArray {
        guard self.count >= 2 else {
            fatalError("This array must contain at least 2 views")
        }
        
        var constraints = LayoutConstraintsArray()
        
        for view in self {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            constraints.append(view.autoSetDimension(dimension, toSize: toSize))
        }
        
        return constraints
    }
    
    public func autoSetViewsDimensionsToSize(size: CGSize) -> LayoutConstraintsArray {
        var constraints = LayoutConstraintsArray()
        
        constraints.appendContentsOf(self.autoSetViewsDimension(.Width, toSize: size.width))
        constraints.appendContentsOf(self.autoSetViewsDimension(.Height, toSize: size.height))
        
        return constraints
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

public class AutoLayoutView: UIView {
    private var constraintsSet = false
    
    func setupInitialConstraints() {
        fatalError("setupInitialConstraints() must be overriden by subclasses")
    }
    
    override public func updateConstraints() {
        if !constraintsSet {
            setupInitialConstraints()
            
            constraintsSet = true
        }
        
        super.updateConstraints()
    }
}
