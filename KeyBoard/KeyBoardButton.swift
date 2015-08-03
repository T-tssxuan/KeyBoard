//
//  KeyBoardButton.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class KeyBoardButton: UIControl {
    var shapeCategory: ShapeCategory! = ShapeCategory.Heart
    var shapePath: CGPathRef!
    var buttonBackgroundColor: CGColorRef!
    var buttonBackgroundImage: UIImage!
    var buttonFrameColor: CGColorRef!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonFrameColor = UIColor.blueColor().CGColor
        buttonBackgroundColor = UIColor.grayColor().CGColor
        shapePath = Shape.getPath(shapeCategory: shapeCategory, frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        var context: CGContextRef = UIGraphicsGetCurrentContext()
//        CGContextSaveGState(context)
        CGContextAddPath(context, self.shapePath)
        CGContextSetFillColorWithColor(context, buttonBackgroundColor)
        CGContextSetStrokeColorWithColor(context, buttonFrameColor)
        CGContextSetLineWidth(context, 2)
        CGContextDrawPath(context, kCGPathFillStroke)
//        CGContextRestoreGState(context)
        print("\nondraw")
    }
    
    func setShape(#shape: Int) {
        shapeCategory = ShapeCategory(rawValue: shape % ShapeCategory.count)!
        shapePath = Shape.getPath(shapeCategory: shapeCategory, frame: self.frame)
        self.setNeedsDisplay()
    }
    
    func setHeight(#height: Float) {
        self.frame.size.height = CGFloat(height)
        self.setNeedsDisplay()
    }
    
    func setWidth(#width: Float) {
        self.frame.size.width = CGFloat(width)
        self.setNeedsDisplay()
    }
    
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        return self
    }
}
