//
//  ShapeItem.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class ShapeItem: UIView {
    var shape:Int = 1
    
    init(frame aRect: CGRect, viewShape shape:Int ) {
        super.init(frame: aRect)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func drawRect(rect: CGRect) {
//        let p = UIBezierPath(roundedRect: rect, cornerRadius: 10)
//        p.lineWidth = 5
//        UIColor.blackColor().setStroke()
//        UIColor.greenColor().setFill()
//        p.fill()
//        p.stroke()
//        print("\(shape)")
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        let outPath: CGPath = CGPathCreateWithRoundedRect(rect, 10, 10, nil)
        
        CGContextAddPath(context, outPath)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor)
        CGContextSetLineWidth(context, 10)
//        CGContextStrokePath(context)
//        CGContextFillPath(context)
        CGContextDrawPath(context, kCGPathFillStroke)
        
        
        CGContextAddPath(context, makeHeartPath(rect: rect))
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor)
        CGContextSetLineWidth(context, 3)
        CGContextDrawPath(context, kCGPathFillStroke)
    }
    
    func makeRoundedRectPath(#rect: CGRect) -> CGMutablePathRef {
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
    
    func makeRectPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRect(path, nil, rect)
        return path
    }
    
    func makeUpTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, rect.width / 2, 0)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    func makeLeftTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, rect.height / 2)
        CGPathAddLineToPoint(path, nil, rect.width, 0)
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    func makeDownTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddLineToPoint(path, nil, rect.width, 0)
        CGPathAddLineToPoint(path, nil, rect.width / 2, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    func makeRightTranglePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddLineToPoint(path, nil, rect.width, rect.height / 2)
        CGPathAddLineToPoint(path, nil, 0, rect.height)
        CGPathCloseSubpath(path)
        return path
    }
    
    func makeCirclePath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddArc(path, nil, rect.width / 2, rect.height / 2, rect.width / 2, 0, CGFloat(M_PI * 2), true)
        return path
    }
    
    func makeHeartPath(#rect: CGRect) -> CGMutablePathRef {
        var path: CGMutablePathRef = CGPathCreateMutable()
        var heartPath: CGMutablePathRef = CGPathCreateMutable()
        var heartSize: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)
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
