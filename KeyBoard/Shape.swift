//
//  Shape.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/2.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

enum ShapeCategory: Int{
    case RoundedRect = 0
    case Rect = 1
    case UpTrangle = 2
    case LeftTrangle = 3
    case DownTrangle = 4
    case RightTrangle = 5
    case Circle = 6
    case Heart = 7
    static var count: Int { return Heart.hashValue + 1}
    static func getCategory(#index: Int) -> ShapeCategory{
        return ShapeCategory(rawValue: index % (Heart.hashValue + 1))!
    }
}

class Shape: NSObject {
    
    static func getPath(#shapeCategory: ShapeCategory, frame rect: CGRect) -> CGPathRef {
        var shapePath: CGPathRef
        switch shapeCategory {
        case .RoundedRect:
            shapePath = makeRoundedRectPath(rect: rect)
        case .Rect:
            shapePath = makeRectPath(rect: rect)
        case .UpTrangle:
            shapePath = makeUpTranglePath(rect: rect)
        case .LeftTrangle:
            shapePath = makeLeftTranglePath(rect: rect)
        case .DownTrangle:
            shapePath = makeDownTranglePath(rect: rect)
        case .RightTrangle:
            shapePath = makeRightTranglePath(rect: rect)
        case .Circle:
            shapePath = makeCirclePath(rect: rect)
        case .Heart:
            shapePath = makeHeartPath(rect: rect)
        default:
            shapePath = makeRoundedRectPath(rect: rect)
        }
        return shapePath
    }
    
    static func makeRoundedRectPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        var transform: CGAffineTransform = CGAffineTransform(
            a: 0.6,
            b: 0,
            c: 0,
            d: 0.6,
            tx: 0.2 * rect.width,
            ty: 0.2 * rect.width
        )
        CGPathAddRoundedRect(path, nil, CGRect(x: 0, y: 0, width: rect.width, height: rect.height),  5, 5)
        
        return path
    }
    
    static func makeRectPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        println("make rect \(rect)")
        return path
    }
    
    static func makeUpTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, rect.width / 2, 0)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    static func makeLeftTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, rect.height / 2)
        CGPathAddLineToPoint(path, nil, rect.width, 0)
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    static func makeDownTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, rect.width, 0)
        CGPathAddLineToPoint(path, nil, rect.width / 2, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    static func makeRightTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, rect.width, rect.height / 2)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    static func makeCirclePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(path, nil, rect.width / 2, rect.height / 2, rect.width / 2, 0, CGFloat(M_PI * 2), true)
        return path
    }
    
    static func makeHeartPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        var heartPath: CGMutablePathRef = CGPathCreateMutable()
        var heartSize: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)
        var transformPos: CGAffineTransform = CGAffineTransform(
            a: rect.width / 120,
            b: 0,
            c: 0,
            d: -rect.height / 120,
            tx: 0,
            ty: 35
        )
        
        var transformSize: CGAffineTransform = CGAffineTransform(
            a: rect.width / heartSize.width,
            b: 0,
            c: 0,
            d: rect.height / heartSize.width,
            tx: 0,
            ty: 0
        )

        
//        CGPathMoveToPoint(heartPath, nil, 0, 21)
//        CGPathAddCurveToPoint(heartPath, nil, -16, 49.8, -53.2, 41.0, -49.6, 5.8)
//        CGPathAddCurveToPoint(heartPath, nil, -46, -29.4, -9.4, -53.4, 0, -69.8)
//        CGPathAddCurveToPoint(heartPath, nil, 9.4, -53.4, 46, -29.4, 49.6, 5.8)
//        CGPathAddCurveToPoint(heartPath, nil, 53.2, 41, 16, 49.8, 0, 21)
//        CGPathCloseSubpath(heartPath)
        
        
        CGPathMoveToPoint(heartPath, nil, 50, 21)
        CGPathAddCurveToPoint(heartPath, nil, 34, 49.8, -3.2, 41.0, 0.4, 5.8)
        CGPathAddCurveToPoint(heartPath, nil, 4, -29.4, 40.6, -53.4, 50, -69.8)
        CGPathAddCurveToPoint(heartPath, nil, 59.4, -53.4, 96, -29.4, 99.6, 5.8)
        CGPathAddCurveToPoint(heartPath, nil, 103.2, 41, 66, 49.8, 50, 21)
        CGPathCloseSubpath(heartPath)

        CGPathAddPath(path, &transformPos, heartPath)
        
        var temp: CGMutablePathRef = CGPathCreateMutable()
        
        return path
    }
}
