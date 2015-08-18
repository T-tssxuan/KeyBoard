//
//  KeyTitleLayer.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/6.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class KeyTitleLayer: CALayer {
    var key: KeyBoardButton!
    override func drawInContext(ctx: CGContext!) {
        
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
        var string: CFAttributedStringRef = CFAttributedStringCreate(nil, key.buttonTitle as CFStringRef, nil)
        var line: CTLineRef = CTLineCreateWithAttributedString(string)
        var temp = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
        CGContextTranslateCTM(ctx, key.frame.height / 2 - temp / 2, key.frame.height / 2)
        CGContextScaleCTM(ctx, 1, -1)
        CGContextSetTextPosition(ctx, 0, 0)
        CGContextSetTextDrawingMode(ctx, kCGTextFill)
        CTLineDraw(line, ctx)
        var image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        
        println("image \(image)")
        println("in the title layer position \(temp) frame \(frame)")
    }
}
