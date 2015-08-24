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

    var buttonBackgroundColor: Int! = 0 {
        didSet {
            println("set bgcolor")
            print("this frame \(frame)")
            shapeLayer.setNeedsDisplay()
        }
    }
    var buttonBackgroundImage: String! = "default" {
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
    
    var actualFrame: CGRect = CGRectZero
    
    var editingFrame: CGRect = CGRectZero
    
    var buttonFunction: String! = "A" {
        didSet {
            println("set the function of the key \(buttonFunction)")
        }
    }
    
    var buttonInfo: JSON!
    
    var moveable: Bool = false
    var isEditing: Bool = false
    
    weak var hostPlay:UIViewControllerPlay!
    
    var imageLayer = KeyImageLayer()
    var shapeLayer = KeyShapeLayer()
    var titleLayer = KeyTitleLayer()
    
    
    init(frame: CGRect, host: UIViewControllerPlay) {
        super.init(frame: frame)
        
        actualFrame = frame
        editingFrame = frame
        
        hostPlay = host
        
        buttonFrameColor = UIColor.blueColor().CGColor
        buttonBackgroundColor = 0
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
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tap)
        var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
        self.addGestureRecognizer(pan)
        
        self.addTarget(self, action: Selector("touchDown:"), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: Selector("touchUp:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        updateLayerFrames()
    }
    
    func pan(temp: UIPanGestureRecognizer) {
        if moveable {
            var point: CGPoint = temp.translationInView(temp.view!)
            self.center = CGPointMake(center.x + point.x, center.y + point.y)
            println("frame \(frame)")
            temp.setTranslation(CGPointZero, inView: temp.view)
        }
    }
    
    func tap(temp: UITapGestureRecognizer) {
        if hostPlay.playStatus != 0 {
            if hostPlay.playStatus == 2 {
                hostPlay.editKey(customKey: self)
            } else if hostPlay.playStatus == 3 {
                hostPlay.deleteKey(customKey: self)
            }
        }
    }
    
    func touchDown(item: UIControl) {
        if !isEditing {
            NetworkManager.sharedInstance.send(msg: buttonFunction + ",000")
            println("button touch down")
        }
    }
    
    func touchUp(item: UIControl) {
        if !isEditing {
            NetworkManager.sharedInstance.send(msg: buttonFunction + ",111")
            println("button touch up")
        }
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
    
    func updateButtonInfo() {
        buttonInfo = [
            "x": actualFrame.origin.x,
            "y": actualFrame.origin.y,
            "width": actualFrame.width,
            "height": actualFrame.height,
            "shape": shapeCategory.rawValue,
            "color": buttonBackgroundColor,
            "title": buttonTitle,
            "image": buttonBackgroundImage,
            "function": buttonFunction
        ]
    }
    
    func setButtonInfo(info settingInfo: JSON?) {
        if let info = settingInfo {
            buttonInfo = info
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        frame = CGRect(
            x: buttonInfo["x"].intValue,
            y: buttonInfo["y"].intValue,
            width: buttonInfo["width"].intValue,
            height: buttonInfo["height"].intValue
        )
        
        actualFrame = frame
        
        shapeCategory =  ShapeCategory.getCategory(index: buttonInfo["shape"].intValue)
        buttonBackgroundColor = buttonInfo["color"].intValue
        buttonTitle = buttonInfo["title"].stringValue
        buttonBackgroundImage = buttonInfo["image"].stringValue
        buttonFunction = buttonInfo["function"].stringValue
        
        CATransaction.commit()
    }
    
    func fromEditingPositionToActualPosition() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.frame = self.actualFrame
        })
    }
    
    func fromActualPositionToEditingPosition() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.frame = self.editingFrame
        })
    }
    
}
