//
//  KeyBoardButton.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import QuartzCore

class KeyBoardButton: UIControl{
    var shapeCategory: ShapeCategory! = ShapeCategory.Circle {
        didSet {
            shapeLayer.setNeedsDisplay()
        }
    }

    var buttonBackgroundColor: CGColorRef! = UIColor.redColor().CGColor {
        didSet {
            println("set bgcolor")
            print("this frame \(frame)")
            shapeLayer.setNeedsDisplay()
        }
    }
    var buttonBackgroundImage: CGImageRef! {
        didSet {
            println("set back ground image")
//            imageLayer.setNeedsDisplay()
        }
    }
    
    var buttonFrameColor: CGColorRef! {
        didSet {
            shapeLayer.setNeedsDisplay()
        }
    }
    var buttonTitle: String! {
        didSet {
            titleLayer.setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    var previouseLocation: CGPoint!
    
    var buttonFunction: String! = "A" {
        didSet {
            println("set the function of the key \(buttonFunction)")
        }
    }
    
    var imageLayer = KeyImageLayer()
    var shapeLayer = KeyShapeLayer()
    var titleLayer = KeyTitleLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonFrameColor = UIColor.blueColor().CGColor
        buttonBackgroundColor = UIColor.grayColor().CGColor
        buttonTitle = "custom"
        
        println("init")
        opaque = false
        
        
        shapeLayer.shadowOffset = CGSize(width: 10, height: 10)
        shapeLayer.key = self
        shapeLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(shapeLayer)
        shapeLayer.setNeedsDisplay()
        
        imageLayer.key = self
        imageLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(imageLayer)

        titleLayer.key = self
        titleLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(titleLayer)
        
        self.addTarget(self, action: "click:", forControlEvents: UIControlEvents.TouchDown)
        var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
        self.addGestureRecognizer(pan)
        
        updateLayerFrames()
    }
    
    func click(temp: UIControl) {
        println("tap in the custom button")
    }
    
    func pan(temp: UIPanGestureRecognizer) {
        var point: CGPoint = temp.translationInView(temp.view!)
        self.center = CGPointMake(center.x + point.x, center.y + point.y)
        println("frame \(frame)")
        temp.setTranslation(CGPointZero, inView: temp.view)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        shapeLayer.setNeedsDisplay()
        
        imageLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        imageLayer.setNeedsDisplay()
        
        titleLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        titleLayer.setNeedsDisplay()
        
        CATransaction.commit()

    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let path = Shape.getPath(shapeCategory: shapeCategory, frame: frame)
        if CGPathContainsPoint(path, nil, point, false) {
            return self as UIView
        } else {
            return nil
        }
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        println("begin tracking")
        return true
    }
    
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        println("end tracking")
    }
    

    func setShape(#shape: Int) {
        shapeCategory = ShapeCategory(rawValue: shape % ShapeCategory.count)!
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
    
}
