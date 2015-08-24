//
//  KeyImageLayer.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/6.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class KeyImageLayer: CALayer {
    var key: KeyBoardButton!
    override func drawInContext(ctx: CGContext!) {
        let width = key.frame.width / 3
        let height = key.frame.height / 3
        let x = key.frame.width / 3
        let y = key.frame.height / 6
        var image: UIImage = UIImage(named: key.buttonBackgroundImage)!
        CGContextSetAlpha(ctx, 1)
        CGContextDrawImage(ctx, CGRect(x: x, y: y, width: width, height: height), image.CGImage)
        println("in image layer")
    }
}
