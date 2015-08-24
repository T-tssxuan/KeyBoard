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
    var pageSettingButton: UIButton!
    
    
    var menuPosition: CGPoint = CGPoint(x: 200, y: 200)
    var menuCenterSize: CGSize = CGSize(width: 50, height: 50)
    var menuSubsidiarySize: CGSize = CGSize(width: 40, height: 40)
    var menuGap: CGFloat = 10
    
    
    override init() {
        super.init()
        pageMenu = UIButton()
        pageMenu.frame = CGRect(
            x: menuPosition.x - menuCenterSize.width,
            y: menuPosition.y - menuCenterSize.height,
            width: menuCenterSize.width,
            height: menuCenterSize.height
        )
        
//        pageMenu.sizeThatFits(menuCenterSize)
        pageMenu.layer.cornerRadius = menuCenterSize.width / 2
        pageMenu.backgroundColor = ColorItem.getColor(index: 0)
        pageMenu.setTitle("Menu", forState: UIControlState.Normal)
        
        pageDismissButton = UIButton()
        pageDismissButton.layer.cornerRadius = menuSubsidiarySize.width / 2
        pageDismissButton.backgroundColor = ColorItem.getColor(index: 1)
        pageDismissButton.setTitle("Menu", forState: UIControlState.Normal)
        
        pageAddButon = UIButton()
        pageAddButon.layer.cornerRadius = menuSubsidiarySize.width / 2
        pageAddButon.backgroundColor = ColorItem.getColor(index: 1)
        pageAddButon.setTitle("Menu", forState: UIControlState.Normal)
        
        pageEditButton = UIButton()
        pageEditButton.layer.cornerRadius = menuSubsidiarySize.width / 2
        pageEditButton.backgroundColor = ColorItem.getColor(index: 1)
        pageEditButton.setTitle("Menu", forState: UIControlState.Normal)
        
        pageSettingButton = UIButton()
        pageSettingButton.layer.cornerRadius = menuSubsidiarySize.width / 2
        pageSettingButton.backgroundColor = ColorItem.getColor(index: 1)
        pageSettingButton.setTitle("Menu", forState: UIControlState.Normal)
        
        updateMenuPosition()
        hideMenuItems()
    }
        
    func showMenuItems() {
        pageDismissButton.hidden = false
        pageAddButon.hidden = false
        pageEditButton.hidden = false
        pageSettingButton.hidden = false
    }
    
    func hideMenuItems() {
        pageDismissButton.hidden = true
        pageAddButon.hidden = true
        pageEditButton.hidden = true
        pageSettingButton.hidden = true
    }
    
    func toggleMenuItems() {
        pageDismissButton.hidden = !pageDismissButton.hidden
        pageAddButon.hidden = !pageAddButon.hidden
        pageEditButton.hidden = !pageEditButton.hidden
        pageSettingButton.hidden = !pageSettingButton.hidden
    }
    
    func updateMenuPosition() {
        
        menuPosition.x = pageMenu.center.x
        menuPosition.y = pageMenu.center.y

        var xOffset = ((menuCenterSize.width + menuSubsidiarySize.width) / 2 + menuGap) / sqrt(2)
        var yOffset =  ((menuCenterSize.height + menuSubsidiarySize.height) / 2 + menuGap) / sqrt(2)
        
        
        pageDismissButton.frame = CGRect(
            x: menuPosition.x - xOffset - menuSubsidiarySize.width / 2,
            y: menuPosition.y - yOffset - menuSubsidiarySize.height / 2,
            width: menuSubsidiarySize.width,
            height: menuSubsidiarySize.height
        )
        pageAddButon.frame = CGRect(
            x: menuPosition.x + xOffset - menuSubsidiarySize.width / 2,
            y: menuPosition.y - yOffset - menuSubsidiarySize.height / 2,
            width: menuSubsidiarySize.width,
            height: menuSubsidiarySize.height
        )
        pageEditButton.frame = CGRect(
            x: menuPosition.x - xOffset - menuSubsidiarySize.width / 2,
            y: menuPosition.y + yOffset - menuSubsidiarySize.height / 2,
            width: menuSubsidiarySize.width,
            height: menuSubsidiarySize.height
        )
        pageSettingButton.frame = CGRect(
            x: menuPosition.x + xOffset - menuSubsidiarySize.width / 2,
            y: menuPosition.y + yOffset - menuSubsidiarySize.height / 2,
            width: menuSubsidiarySize.width,
            height: menuSubsidiarySize.height
        )
        println("the positon: \(pageMenu.frame) \(pageDismissButton.frame)")
    }
}
