//
//  ColorItem.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/1.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class ColorItem: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    static let colorMap = [
        0: UIColor(red: 30 / 256, green: 158 / 256, blue: 73 / 256, alpha: 1),
        1: UIColor(red: 240 / 256, green: 87 / 256, blue: 30 / 256, alpha: 1),
        2: UIColor(red: 53 / 256, green: 53 / 256, blue: 53 / 256, alpha: 1),
        3: UIColor(red: 247 / 256, green: 227 / 256, blue: 87 / 256, alpha: 1),
        4: UIColor(red: 172 / 256, green: 97 / 256, blue: 230 / 256, alpha: 1),
        5: UIColor(red: 69 / 256, green: 190 / 256, blue: 200 / 256, alpha: 1),
        6: UIColor(red: 241 / 256, green: 107 / 256, blue: 105 / 256, alpha: 1),
        7: UIColor(red: 174 / 256, green: 188 / 256, blue: 184 / 256, alpha: 1),
        8: UIColor(red: 233 / 256, green: 231 / 256, blue: 231 / 256, alpha: 1),
        9: UIColor(red: 40 / 256, green: 165 / 256, blue: 207 / 256, alpha: 1)
    ]

    
    static func getColor(#index: Int) -> UIColor {
        return colorMap[index % colorMap.count]!
    }
    
    static func getCGColor(#index: Int) -> CGColorRef {
        return colorMap[index % colorMap.count]!.CGColor!
    }

}
