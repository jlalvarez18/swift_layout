//
//  SLDefines.swift
//  Plugd Mac
//
//  Created by Juan Alvarez on 2/9/16.
//  Copyright © 2016 Juan Alvarez. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    
    public typealias SLView                                     = UIView
    public typealias SLEdgeInsets                               = UIEdgeInsets
    public typealias SLEdgeInsetsZero                           = UIEdgeInsetsZero
    public typealias SLEdgeInsetsMake                           = UIEdgeInsetsMake
    
    public typealias SLLayoutConstraintAxis                     = UILayoutConstraintAxis
    public typealias SLLayoutConstraintOrientation              = ALLayoutConstraintAxis
    public typealias SLLayoutConstraintAxisHorizontal           = UILayoutConstraintAxisHorizontal
    public typealias SLLayoutConstraintAxisVertical             = UILayoutConstraintAxisVertical
    public typealias SLLayoutConstraintOrientationHorizontal    = ALLayoutConstraintAxisHorizontal
    public typealias SLLayoutConstraintOrientationVertical      = ALLayoutConstraintAxisVertical
    
    public typealias SLLayoutPriority                           = UILayoutPriority
    public typealias SLLayoutPriorityRequired                   = UILayoutPriorityRequired
    public typealias SLLayoutPriorityDefaultHigh                = UILayoutPriorityDefaultHigh
    public typealias SLLayoutPriorityDefaultLow                 = UILayoutPriorityDefaultLow
    public typealias SLLayoutPriorityFittingSizeLevel           = UILayoutPriorityFittingSizeLevel
    public typealias SLLayoutPriorityFittingSizeCompression     = SLLayoutPriorityFittingSizeLevel
    public typealias SLLayoutPriorityDragThatCanResizeWindow    = SLLayoutPriorityDefaultHigh
    public typealias SLLayoutPriorityDragThatCannotResizeWindow = SLLayoutPriorityDefaultHigh
    public typealias SLLayoutPriorityWindowSizeStayPut          = SLLayoutPriorityDefaultHigh
#else
    import Cocoa
    
    public typealias SLView                                 = NSView
    public typealias SLEdgeInsets                           = NSEdgeInsets
    public let SLEdgeInsetsZero                             = NSEdgeInsetsZero
    public let SLEdgeInsetsMake                             = NSEdgeInsetsMake
   
    public typealias SLLayoutConstraintOrientation          = NSLayoutConstraintOrientation
    public typealias SLLayoutConstraintAxis                 = NSLayoutConstraintOrientation
    public let SLLayoutConstraintOrientationHorizontal      = NSLayoutConstraintOrientation.Horizontal
    public let SLLayoutConstraintOrientationVertical        = NSLayoutConstraintOrientation.Vertical
    public let SLLayoutConstraintAxisHorizontal             = NSLayoutConstraintOrientation.Horizontal
    public let SLLayoutConstraintAxisVertical               = NSLayoutConstraintOrientation.Vertical
    
    public typealias SLLayoutPriority                       = NSLayoutPriority
    public let SLLayoutPriorityRequired                     = NSLayoutPriorityRequired
    public let SLLayoutPriorityDefaultHigh                  = NSLayoutPriorityDefaultHigh
    public let SLLayoutPriorityDefaultLow                   = NSLayoutPriorityDefaultLow
    public let SLLayoutPriorityFittingSizeLevel             = NSLayoutPriorityFittingSizeCompression
    public let SLLayoutPriorityFittingSizeCompression       = NSLayoutPriorityFittingSizeCompression
    public let SLLayoutPriorityDragThatCanResizeWindow      = NSLayoutPriorityDragThatCanResizeWindow
    public let SLLayoutPriorityDragThatCannotResizeWindow   = NSLayoutPriorityDragThatCannotResizeWindow
    public let SLLayoutPriorityWindowSizeStayPut            = NSLayoutPriorityWindowSizeStayPut
#endif

public typealias LayoutConstraintsArray = [NSLayoutConstraint]
public typealias SLConstraintsBlock = () -> Void
public typealias SLViewConstraintsBlock = (view: SLView) -> Void

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

public enum SLPriority {
    case Required
    case High
    case Low
    case Custom(Float)
    
    var layoutPriority: SLLayoutPriority {
        switch self {
        case .Required:             return SLLayoutPriorityRequired
        case .High:                 return SLLayoutPriorityDefaultHigh
        case .Low:                  return SLLayoutPriorityDefaultLow
        case .Custom(let value):    return value
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
        case .Vertical:         return .AxisVertical
        case .Horizontal:       return .AxisHorizontal
        case .Baseline:         return .AxisBaseline
        case .LastBaseline:     return .AxisLastBaseline
        case .FirstBaseline:    return .AxisFirstBaseline
        }
    }
    
    var constraintAxis: SLLayoutConstraintAxis {
        switch self {
        case .Vertical: return SLLayoutConstraintAxis.Vertical
        case .Horizontal, .Baseline, .FirstBaseline, .LastBaseline:
            return SLLayoutConstraintAxis.Horizontal
        }
    }
    
    #if os(iOS) || os(tvOS)
    var slMarginAttribute: SLAttribute {
        switch self {
        case .Vertical:     return .MarginAxisVertical
        case .Horizontal:   return .MarginAxisHorizontal
        case .Baseline, .LastBaseline, .FirstBaseline:
            fatalError("The baseline axis attributes do not have corresponding margin axis attributes")
        }
    }
    #endif
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
        case .Left:     return .Left
        case .Right:    return .Right
        case .Top:      return .Top
        case .Bottom:   return .Bottom
        case .Leading:  return .Leading
        case .Trailing: return .Trailing
        }
    }
    
    #if os(iOS) || os(tvOS)
    var margin: SLMargin {
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
#endif

public enum SLAlignment {
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
    
    var slAttribute: SLAttribute {
        #if os(iOS) || os(tvOS)
            switch self {
            case .Vertical:         return .AxisVertical
            case .Horizontal:       return .AxisHorizontal
            case .Baseline:         return .AxisBaseline
            case .FirstBaseline:    return .AxisFirstBaseline
            case .Top:              return .Top
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

public enum SLDimension {
    case Width
    case Height
    
    var slAttribute: SLAttribute {
        switch self {
        case .Width:    return .Width
        case .Height:   return .Height
        }
    }
}
