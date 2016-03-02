//
//  SLArray.swift
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

public extension CollectionType where Generator.Element: SLView {
    
    public func autoAlignViewsToEdge(edge: SLEdge) -> LayoutConstraintsArray {
        guard self.count >= 2 else {
            fatalError("This array must contain at least 2 views")
        }
        
        var constraints = LayoutConstraintsArray()
        var previousView: SLView?
        
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
        var previousView: SLView?
        
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
        var previousView: SLView?
        
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
    
    public func autoDistributeViewsAlong(
        axis: SLAxis,
        alignedTo alignment: SLAlignment,
        withFixedSpacing spacing: CGFloat,
        insetSpacing shouldSpaceInsets: Bool = true,
        matchedSizes shouldMatchSizes: Bool = true) -> LayoutConstraintsArray
    {
        guard self.count >= 1 else {
            fatalError("This array must contain at least 1 view to distribute.")
        }
        
        let matchedDimension: SLDimension
        let firstEdge: SLEdge
        let lastEdge: SLEdge
        
        switch axis {
        case .Horizontal, .Baseline, .FirstBaseline:
            matchedDimension = .Width
            firstEdge = .Leading
            lastEdge = .Trailing
        case .Vertical:
            matchedDimension = .Height
            firstEdge = .Top
            lastEdge = .Bottom
        default:
            fatalError("Not a valid axis")
        }
        
        let leadingSpacing = shouldSpaceInsets ? spacing : 0.0
        let trailingSpacing = shouldSpaceInsets ? spacing : 0.0
        
        var constraints = LayoutConstraintsArray()
        
        var previousView: SLView?
        
        for view in self {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if let previousView = previousView {
                constraints.append(view.autoPinEdge(firstEdge, toEdge: lastEdge, ofView: previousView, withOffset: spacing))
                
                if shouldMatchSizes {
                    constraints.append(view.autoMatchDimension(matchedDimension, toDimension: matchedDimension, ofView: previousView))
                }
                
                constraints.append(view.autoAlign(alignment: alignment, toView: previousView, forAxis: axis))
            } else {
                // First view
                constraints.append(view.autoPinEdgeToSuperViewEdge(firstEdge, inset: leadingSpacing))
            }
            
            previousView = view
        }
        
        if let previousView = previousView {
            constraints.append(previousView.autoPinEdgeToSuperViewEdge(lastEdge, inset: trailingSpacing))
        }
        
        return constraints
    }
}