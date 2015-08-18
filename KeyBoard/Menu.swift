//
//  Menu.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/19.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class Menu: NSObject {
    var pageMenu: UIButton!
    var pageDismissButton: UIButton!
    var pageAddButon: UIButton!
    var pageEditButton: UIButton!
    
    var view: UIView!
    
    init(spuerView: UIView) {
        super.init()
        view = spuerView
        pageMenu = UIButton(frame: CGRect(x: 100, y: 100, width: 30, height: 30))
        pageMenu.layer.cornerRadius = 15
        pageMenu.backgroundColor = ColorItem.getColor(index: 0)
        pageMenu.setTitle("Menu", forState: UIControlState.Normal)
        
        pageDismissButton = UIButton(frame: CGRect(x: 80, y: 80, width: 20, height: 20))
        pageDismissButton.layer.cornerRadius = 10
        pageDismissButton.backgroundColor = ColorItem.getColor(index: 1)
        pageDismissButton.setTitle("Menu", forState: UIControlState.Normal)
        
        view.addSubview(pageMenu)
        view.addSubview(pageDismissButton)
    }
    
    func addMenu() {
        
    }
}
