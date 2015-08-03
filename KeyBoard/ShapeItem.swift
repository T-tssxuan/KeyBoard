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
        shapeCategory = ShapeCategory(rawValue: shape % ShapeCategory.count)!
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
        
        var shapePath: CGPathRef = Shape.getPath(shapeCategory: shapeCategory, frame: rect)
        
        CGContextSaveGState(context)
        CGContextScaleCTM(context, 0.7, 0.7)
        CGContextTranslateCTM(context, rect.width * 0.2, rect.height * 0.2)
        CGContextAddPath(context, shapePath)
        
        CGContextSetFillColorWithColor(context, UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 3)
        CGContextDrawPath(context, kCGPathFillStroke)
        CGContextRestoreGState(context)
    }
    

}
