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
}

class Shape: NSObject {
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
        CGPathAddRoundedRect(path, nil, rect,  5, 5)
        
        return path
    }
    
    static func makeRectPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRect(path, nil, rect)
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
        var heartSize: CGRect = CGRect(x: 0, y: 0, width: 150, height: 150)
        var transform: CGAffineTransform = CGAffineTransform(
            a: -rect.width / heartSize.width,
            b: 0,
            c: 0,
            d: -rect.height / heartSize.width,
            tx: 35,
            ty: 27
        )
        
        CGPathMoveToPoint(heartPath, nil, 0, 21)
        CGPathAddCurveToPoint(heartPath, nil, -16, 49.8, -53.2, 41.0, -49.6, 5.8)
        CGPathAddCurveToPoint(heartPath, nil, -46, -29.4, -9.4, -53.4, 0, -69.8)
        CGPathAddCurveToPoint(heartPath, nil, 9.4, -53.4, 46, -29.4, 49.6, 5.8)
        CGPathAddCurveToPoint(heartPath, nil, 53.2, 41, 16, 49.8, 0, 21)
        CGPathCloseSubpath(heartPath)
        
        //        CGPathAddCurveToPoint(heartPath, nil, 75,37,70,25,50,25)
        //
        //        CGPathAddCurveToPoint(heartPath, nil, 75,37,70,25,50,25);
        //        CGPathAddCurveToPoint(heartPath, nil, 20,25,20,62.5,20,62.5);
        //
        //        CGPathAddCurveToPoint(heartPath, nil, 20,80,40,102,75,120);
        //        CGPathAddCurveToPoint(heartPath, nil, 110,102,130,80,130,62.5);
        //
        //        CGPathAddCurveToPoint(heartPath, nil, 130,62.5,130,25,100,25);
        //        CGPathAddCurveToPoint(heartPath, nil, 85,25,75,37,75,40);
        //        CGPathCloseSubpath(heartPath)
        
        CGPathAddPath(path, &transform, heartPath)
        return path
    }
}
