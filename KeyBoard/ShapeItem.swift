//
//  ShapeItem.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit


class ShapeItem: UIView {
    var shapeCategory:ShapeCategory!
    
    init(frame aRect: CGRect, viewShape shape:Int ) {
        super.init(frame: aRect)
        shapeCategory = ShapeCategory(rawValue: shape % 8)!
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        let outPath: CGPathRef = CGPathCreateWithRoundedRect(rect, 10, 10, nil)
        
        CGContextAddPath(context, outPath)
        CGContextSetFillColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 0.05 * rect.height)
        CGContextDrawPath(context, kCGPathFillStroke)
        
        var shapePath: CGPathRef
        switch shapeCategory! {
        case .RoundedRect:
            shapePath = Shape.makeRoundedRectPath(rect: rect)
        case .Rect:
            shapePath = Shape.makeRectPath(rect: rect)
        case .UpTrangle:
            shapePath = Shape.makeUpTranglePath(rect: rect)
        case .LeftTrangle:
            shapePath = Shape.makeLeftTranglePath(rect: rect)
        case .DownTrangle:
            shapePath = Shape.makeDownTranglePath(rect: rect)
        case .RightTrangle:
            shapePath = Shape.makeRightTranglePath(rect: rect)
        case .Circle:
            shapePath = Shape.makeCirclePath(rect: rect)
        case .Heart:
            shapePath = Shape.makeHeartPath(rect: rect)
        default:
            shapePath = Shape.makeRoundedRectPath(rect: rect)
        }
        
        CGContextSaveGState(context)
        CGContextScaleCTM(context, 0.7, 0.7)
        CGContextTranslateCTM(context, rect.width * 0.2, rect.height * 0.2)
        CGContextAddPath(context, shapePath)
        
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 3)
        CGContextDrawPath(context, kCGPathFillStroke)
        CGContextRestoreGState(context)
    }
    

}
