//
//  SADefines.swift
//  Plugd Mac
//
//  Created by Juan Alvarez on 2/9/16.
//  Copyright © 2016 Juan Alvarez. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    
    public typealias SAView                                     = UIView
    public typealias SAEdgeInsets                               = UIEdgeInsets
    public let SAEdgeInsetsZero                                 = UIEdgeInsetsZero
    public let SAEdgeInsetsMake                                 = UIEdgeInsetsMake
    
    public typealias SALayoutConstraintAxis                     = UILayoutConstraintAxis
    public typealias SALayoutConstraintOrientation              = UILayoutConstraintAxis
    public let SALayoutConstraintAxisHorizontal                 = UILayoutConstraintAxis.Horizontal
    public let SALayoutConstraintAxisVertical                   = UILayoutConstraintAxis.Vertical
    public let SALayoutConstraintOrientationHorizontal          = UILayoutConstraintAxis.Horizontal
    public let SALayoutConstraintOrientationVertical            = UILayoutConstraintAxis.Vertical
    
    public typealias SALayoutPriority                           = UILayoutPriority
    public let SALayoutPriorityRequired                         = UILayoutPriorityRequired
    public let SALayoutPriorityDefaultHigh                      = UILayoutPriorityDefaultHigh
    public let SALayoutPriorityDefaultLow                       = UILayoutPriorityDefaultLow
    public let SALayoutPriorityFittingSizeLevel                 = UILayoutPriorityFittingSizeLevel
    public let SALayoutPriorityFittingSizeCompression           = UILayoutPriorityFittingSizeLevel
    public let SALayoutPriorityDragThatCanResizeWindow          = UILayoutPriorityDefaultHigh
    public let SALayoutPriorityDragThatCannotResizeWindow       = UILayoutPriorityDefaultHigh
    public let SALayoutPriorityWindowSizeStayPut                = UILayoutPriorityDefaultHigh
#else
    import Cocoa
    
    public typealias SAView                                 = NSView
    public typealias SAEdgeInsets                           = NSEdgeInsets
    public let SAEdgeInsetsZero                             = NSEdgeInsetsZero
    public let SAEdgeInsetsMake                             = NSEdgeInsetsMake
   
    public typealias SALayoutConstraintOrientation          = NSLayoutConstraintOrientation
    public typealias SALayoutConstraintAxis                 = NSLayoutConstraintOrientation
    public let SALayoutConstraintOrientationHorizontal      = NSLayoutConstraintOrientation.Horizontal
    public let SALayoutConstraintOrientationVertical        = NSLayoutConstraintOrientation.Vertical
    public let SALayoutConstraintAxisHorizontal             = NSLayoutConstraintOrientation.Horizontal
    public let SALayoutConstraintAxisVertical               = NSLayoutConstraintOrientation.Vertical
    
    public typealias SALayoutPriority                       = NSLayoutPriority
    public let SALayoutPriorityRequired                     = NSLayoutPriorityRequired
    public let SALayoutPriorityDefaultHigh                  = NSLayoutPriorityDefaultHigh
    public let SALayoutPriorityDefaultLow                   = NSLayoutPriorityDefaultLow
    public let SALayoutPriorityFittingSizeLevel             = NSLayoutPriorityFittingSizeCompression
    public let SALayoutPriorityFittingSizeCompression       = NSLayoutPriorityFittingSizeCompression
    public let SALayoutPriorityDragThatCanResizeWindow      = NSLayoutPriorityDragThatCanResizeWindow
    public let SALayoutPriorityDragThatCannotResizeWindow   = NSLayoutPriorityDragThatCannotResizeWindow
    public let SALayoutPriorityWindowSizeStayPut            = NSLayoutPriorityWindowSizeStayPut
#endif

public typealias LayoutConstraintsArray = [NSLayoutConstraint]
public typealias SAConstraintsBlock = () -> Void
public typealias SAViewConstraintsBlock = (view: SAView) -> Void

public enum SAAttribute {
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
    
    #if os(iOS) || os(tvOS)
    case MarginLeft
    case MarginRight
    case MarginTop
    case MarginBottom
    case MarginLeading
    case MarginTrailing
    case MarginAxisVertical
    case MarginAxisHorizontal
    #endif
    
    var layoutAttribute: NSLayoutAttribute {
        #if os(iOS) || os(tvOS)
            switch self {
            case .Left:                 return NSLayoutAttribute.Left
            case .Right:                return NSLayoutAttribute.Right
            case .Top:                  return NSLayoutAttribute.Top
            case .Bottom:               return NSLayoutAttribute.Bottom
            case .Leading:              return NSLayoutAttribute.Leading
            case .Trailing:             return NSLayoutAttribute.Trailing
            case .Width:                return NSLayoutAttribute.Width
            case .Height:               return NSLayoutAttribute.Height
            case .AxisVertical:         return NSLayoutAttribute.CenterX
            case .AxisHorizontal:       return NSLayoutAttribute.CenterY
            case .AxisBaseline:         return NSLayoutAttribute.Baseline
            case .AxisFirstBaseline:    return NSLayoutAttribute.FirstBaseline
            case .AxisLastBaseline:     return NSLayoutAttribute.LastBaseline
            case .MarginLeft:           return NSLayoutAttribute.LeftMargin
            case .MarginRight:          return NSLayoutAttribute.RightMargin
            case .MarginTop:            return NSLayoutAttribute.TopMargin
            case .MarginBottom:         return NSLayoutAttribute.BottomMargin
            case .MarginLeading:        return NSLayoutAttribute.LeadingMargin
            case .MarginTrailing:       return NSLayoutAttribute.TrailingMargin
            case .MarginAxisVertical:   return NSLayoutAttribute.CenterXWithinMargins
            case .MarginAxisHorizontal: return NSLayoutAttribute.CenterYWithinMargins
            }
        #else
            switch self {
            case .Left:                 return NSLayoutAttribute.Left
            case .Right:                return NSLayoutAttribute.Right
            case .Top:                  return NSLayoutAttribute.Top
            case .Bottom:               return NSLayoutAttribute.Bottom
            case .Leading:              return NSLayoutAttribute.Leading
            case .Trailing:             return NSLayoutAttribute.Trailing
            case .Width:                return NSLayoutAttribute.Width
            case .Height:               return NSLayoutAttribute.Height
            case .AxisVertical:         return NSLayoutAttribute.CenterX
            case .AxisHorizontal:       return NSLayoutAttribute.CenterY
            case .AxisBaseline:         return NSLayoutAttribute.Baseline
            case .AxisFirstBaseline:    return NSLayoutAttribute.FirstBaseline
            case .AxisLastBaseline:     return NSLayoutAttribute.LastBaseline
            }
        #endif
    }
}

public enum SAPriority {
    case Required
    case High
    case Low
    case Custom(Float)
    
    var layoutPriority: SALayoutPriority {
        switch self {
        case .Required:             return SALayoutPriorityRequired
        case .High:                 return SALayoutPriorityDefaultHigh
        case .Low:                  return SALayoutPriorityDefaultLow
        case .Custom(let value):    return value
        }
    }
}

public enum SAAxis {
    case Vertical
    case Horizontal
    case Baseline
    case LastBaseline
    case FirstBaseline
    
    var slAttribute: SAAttribute {
        switch self {
        case .Vertical:         return .AxisVertical
        case .Horizontal:       return .AxisHorizontal
        case .Baseline:         return .AxisBaseline
        case .LastBaseline:     return .AxisLastBaseline
        case .FirstBaseline:    return .AxisFirstBaseline
        }
    }
    
    var constraintAxis: SALayoutConstraintAxis {
        switch self {
        case .Vertical: return SALayoutConstraintAxis.Vertical
        case .Horizontal, .Baseline, .FirstBaseline, .LastBaseline:
            return SALayoutConstraintAxis.Horizontal
        }
    }
    
    #if os(iOS) || os(tvOS)
    var slMarginAttribute: SAAttribute {
        switch self {
        case .Vertical:     return .MarginAxisVertical
        case .Horizontal:   return .MarginAxisHorizontal
        case .Baseline, .LastBaseline, .FirstBaseline:
            fatalError("The baseline axis attributes do not have corresponding margin axis attributes")
        }
    }
    #endif
}

public enum SAEdge {
    case Left
    case Right
    case Top
    case Bottom
    case Leading
    case Trailing
    
    var slAttribute: SAAttribute {
        switch self {
        case .Left:     return .Left
        case .Right:    return .Right
        case .Top:      return .Top
        case .Bottom:   return .Bottom
        case .Leading:  return .Leading
        case .Trailing: return .Trailing
        }
    }
    
    #if os(iOS) || os(tvOS)
    var margin: SAMargin {
        switch self {
        case .Left:     return .Left
        case .Right:    return .Right
        case .Top:      return .Top
        case .Bottom:   return .Bottom
        case .Leading:  return .Leading
        case .Trailing: return .Trailing
        }
    }
    #endif
}

#if os(iOS) || os(tvOS)
    public enum SAMargin {
        case Left
        case Right
        case Top
        case Bottom
        case Leading
        case Trailing
        
        var slAttribute: SAAttribute {
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
#endif

public enum SAAlignment {
    case Vertical
    case Horizontal
    case Baseline
    
    #if os(iOS) || os(tvOS)
    case FirstBaseline
    #endif
    
    case Top
    case Left
    case Bottom
    case Right
    case Leading
    case Trailing
    
    var slAttribute: SAAttribute {
        #if os(iOS) || os(tvOS)
            switch self {
            case .Vertical:         return .AxisVertical
            case .Horizontal:       return .AxisHorizontal
            case .Baseline:         return .AxisBaseline
            case .FirstBaseline:    return .AxisFirstBaseline
            case .Top:              return .Top
            case .Left:             return .Left
            case .Bottom:           return .Bottom
            case .Right:            return .Right
            case .Leading:          return .Leading
            case .Trailing:         return .Trailing
            }
        #else
            switch self {
            case .Vertical:     return .AxisVertical
            case .Horizontal:   return .AxisHorizontal
            case .Baseline:     return .AxisBaseline
            case .Top:          return .Top
            case .Left:         return .Left
            case .Bottom:       return .Bottom
            case .Right:        return .Right
            case .Leading:      return .Leading
            case .Trailing:     return .Trailing
            }
        #endif
    }
}

public enum SADimension {
    case Width
    case Height
    
    var slAttribute: SAAttribute {
        switch self {
        case .Width:    return .Width
        case .Height:   return .Height
        }
    }
}
