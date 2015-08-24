//
//  KeyShapeLayer.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/6.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import QuartzCore

class KeyShapeLayer: CALayer {
    var key: KeyBoardButton!
        
    override func drawInContext(ctx: CGContext!) {
//        CGContextSaveGState(ctx)
        println("\(frame)")
        CGContextSetFillColorWithColor(ctx, ColorItem.getCGColor(index: key.buttonBackgroundColor))
        CGContextSetStrokeColorWithColor(ctx, key.buttonFrameColor)
        CGContextSetLineWidth(ctx, 1)
        let path: CGPathRef = Shape.getPath(shapeCategory: key.shapeCategory, frame: frame)
        CGContextAddPath(ctx, path)
//        CGContextDrawPath(ctx, kCGPathFill)
        CGContextFillPath(ctx)
//        CGContextRestoreGState(ctx)
        println("in shape layer")
    }
    
//    override func needsDisplay() -> Bool {
//        return true
//    }
    
}
