//
//  ViewController.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/7/26.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import Foundation


extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var home: HomePage?
    var collectionView: UICollectionView!
    var appInfo: [String: AnyObject]!
    
    var editingCellIndex: NSIndexPath?
    var editingStatus: Bool! = false
    var editingPreSubviews: [AnyObject]!
    var editingCellInfo: JSON? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(setStatusBarBackgroundView())
//        InfoManager.setItems()
        InfoManager.getItems()
        InfoManager.saveItems()
        home =  HomePage()
        collectionView = home!.getHomeView()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let gesture = UILongPressGestureRecognizer(target: self, action: "longPressHandle:")
        collectionView.addGestureRecognizer(gesture)
        
        view.addSubview(collectionView)
        
        let note = NSNotificationCenter.defaultCenter()
        note.addObserver(self, selector: "networkHandle:", name: "network_info", object: nil)
        
        NetworkManager.sharedInstance.connect()
        NetworkManager.sharedInstance.send(msg: "hello world")
    }
    
    func longPressHandle(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        println("int the long press")
        let p = gestureRecognizer.locationInView(collectionView)
        editingCellIndex = collectionView.indexPathForItemAtPoint(p)
        
        if editingCellIndex?.row == 0 || editingCellIndex?.row == InfoManager.getHomeSetting().count - 1 {
            return
        }
        if editingStatus! {
            changeCellToNormalMode()
        }
        if editingCellIndex != nil {
            editingStatus = true
            changeCellToEditMode()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkHandle(sender: NSNotification) {
        println("home recieve a notification")
        var msg: String = sender.name
        var userInfo = sender.userInfo as! Dictionary<String, AnyObject>
        var info = userInfo["status"] as! String

        if info == "error" {
            var count = userInfo["try_count"] as? String
            info = info + " try:" + count!
        }
        
        var itemInfo: JSON = InfoManager.getHomeSettingAtIndex(0)
        itemInfo["title"].string = info
        if info == "connected" {
            itemInfo["image"] = "signal"
        } else {
            itemInfo["image"] = "signal_disable"
        }
        
        InfoManager.setHomeSettingAtIndex(0, info: itemInfo)
        println("the info \(InfoManager.getHomeSetting())")
        
        home?.updateHomeInfo()
        collectionView.reloadItemsAtIndexPaths([NSIndexPath(index: 0)])
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func setStatusBarBackgroundView()->UIView {
        var bgView:UIView!
        switch UIDevice.currentDevice().orientation {
        case UIDeviceOrientation.Portrait, UIDeviceOrientation.PortraitUpsideDown, UIDeviceOrientation.Unknown:
            bgView = UIView(frame:
                CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
            )
            println("blabla")
        default:
            bgView = UIView(frame:
                CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.height, height: 20.0)
            )
        }
        if bgView != nil {
            println("\(bgView.frame.size)")
        }
        bgView.backgroundColor = UIColor.blackColor()
        
        return bgView
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = home!.getCellAtIndexPath(indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("the number \(InfoManager.getHomeSetting().count)")
        return InfoManager.getHomeSetting().count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editingStatus! {
            return
        }
        
        if indexPath.row != InfoManager.getHomeSetting().count - 1 && indexPath.row != 0{
            let item: JSON = InfoManager.getHomeItemInformation(index: indexPath.row)
            let pageTitle: String = item["title"].stringValue
            println("subpage info: \(pageTitle)")
            let pageInfo = InfoManager.getSubpageInformation(pageName: pageTitle)
            self.presentViewController(UIViewControllerPlay(pageInfo: pageInfo, name: pageTitle, mouse: true), animated: true, completion: nil)
        } else if indexPath.row == 0 {
            self.presentViewController(NetworkViewController(), animated: true, completion: { () -> Void in
                NetworkManager.sharedInstance.connect()
            })
        }
//        NetworkManager.sharedInstance.send(msg: "abc")
        println("the deselect index is: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("the select index is: \(indexPath.row)")
    }
    
    var editCellBtn: UIButton!
    var deleteCellBtn: UIButton!
    var okCellBtn: UIButton!
    var cancelCellBtn: UIButton!
    
    func changeCellToEditMode() {
        let editingCell = collectionView.cellForItemAtIndexPath(editingCellIndex!)
        let width = editingCell!.contentView.frame.width / 2
        let height = editingCell!.contentView.frame.height / 2
        
        editCellBtn = UIButton(frame: CGRect(x: -width, y: -height, width: width, height: height))
        editCellBtn.alpha = 0
        editCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row)
        editCellBtn.setTitle("Edit", forState: UIControlState.Normal)
        editCellBtn.addTarget(self, action: "editCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(editCellBtn)
        
        deleteCellBtn = UIButton(frame: CGRect(x: width + width, y: -height, width: width, height: height))
        deleteCellBtn.alpha = 0
        deleteCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 1)
        deleteCellBtn.setTitle("Delete", forState: UIControlState.Normal)
        deleteCellBtn.addTarget(self, action: "deleteCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(deleteCellBtn)
        
        okCellBtn = UIButton(frame: CGRect(x: -width, y: height + height, width: width, height: height))
        okCellBtn.alpha = 0
        okCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 2)
        okCellBtn.setTitle("Ok", forState: UIControlState.Normal)
        okCellBtn.addTarget(self, action: "okCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(okCellBtn)
        
        cancelCellBtn = UIButton(frame: CGRect(x: width + width, y: height + height, width: width, height: height))
        cancelCellBtn.alpha = 0
        cancelCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 3)
        cancelCellBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelCellBtn.addTarget(self, action: "cancelCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(cancelCellBtn)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.editCellBtn.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.deleteCellBtn.frame = CGRect(x: width, y: 0, width: width, height: height)
            self.okCellBtn.frame = CGRect(x: 0, y: height, width: width, height: height)
            self.cancelCellBtn.frame = CGRect(x: width, y: height, width: width, height: height)
            self.editCellBtn.alpha = 1
            self.deleteCellBtn.alpha = 1
            self.okCellBtn.alpha = 1
            self.cancelCellBtn.alpha = 1
        })
    }
    
    func changeCellToNormalMode() {
        var cell = collectionView.cellForItemAtIndexPath(editingCellIndex!)
        let width = cell!.contentView.frame.width / 2
        let height = cell!.contentView.frame.height / 2
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.editCellBtn.frame = CGRect(x: -width, y: -height, width: width, height: height)
            self.deleteCellBtn.frame = CGRect(x: width + width, y: -height, width: width, height: height)
            self.okCellBtn.frame = CGRect(x: -width, y: height + height, width: width, height: height)
            self.cancelCellBtn.frame = CGRect(x: width + width, y: height + height, width: width, height: height)
            self.editCellBtn.alpha = 0
            self.deleteCellBtn.alpha = 0
            self.okCellBtn.alpha = 0
            self.cancelCellBtn.alpha = 0
            }) { (finished: Bool) -> Void in
                self.editCellBtn.removeFromSuperview()
                self.deleteCellBtn.removeFromSuperview()
                self.okCellBtn.removeFromSuperview()
                self.cancelCellBtn.removeFromSuperview()
                self.editCellBtn = nil
                self.deleteCellBtn = nil
                self.okCellBtn = nil
                self.cancelCellBtn = nil
        }
    }
    
    
    var editingCover: UIView?
    var editingPanel: UIView?
    
    func editCellBtnClick(sender: UIButton) {
        editingCellInfo = InfoManager.getHomeSettingAtIndex(editingCellIndex!.row)
        editingCover = UIView(frame: UIScreen.mainScreen().bounds)
        editingCover!.backgroundColor = UIColor.whiteColor()
        editingCover!.alpha = 0
        view.addSubview(editingCover!)
        
        editingPanel = UIView(
            frame: CGRect(
                x: 0,
                y: UIScreen.mainScreen().bounds.height * 0.2,
                width: UIScreen.mainScreen().bounds.width,
                height: UIScreen.mainScreen().bounds.height * 0.5
            )
        )
        editingPanel!.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row)
        editingPanel!.alpha = 0
        configureEditingPanel()
        view.addSubview(editingPanel!)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.editingCover!.alpha = 0.4
            self.editingPanel!.alpha = 1
        })
        
    }
    
    func deleteCellBtnClick(sender: UIButton) {
        println("the editingCellIndex \(editingCellIndex)")
        var homeInfo = InfoManager.getHomeSetting()
        homeInfo.arrayObject?.removeAtIndex(editingCellIndex!.row + 1)
        
        collectionView.performBatchUpdates({ () -> Void in
            InfoManager.setHomeSetting(homeSeting: homeInfo)
            self.collectionView.reloadData()
            self.collectionView.deleteItemsAtIndexPaths([self.editingCellIndex!])
        }, completion: nil)
        
        editingCellIndex = nil
        editingPreSubviews = []
        editingStatus = false
    }
    
    func okCellBtnClick(sender: UIButton) {
        editingStatus = false
        if editingCellInfo != nil {
            InfoManager.setHomeSettingAtIndex(editingCellIndex!.row, info: editingCellInfo!)
            editingCellInfo = nil
        }
        changeCellToNormalMode()
        home!.updateHomeInfo()
        collectionView.reloadData()
    }
    
    func cancelCellBtnClick(sender: UIButton) {
        editingStatus = false
        changeCellToNormalMode()
    }
    
    func configureEditingPanel() {
        let width = editingPanel!.frame.width
        let height = editingPanel!.frame.height
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height * 0.1))
        title.text = "Set the " + editingCellInfo!["title"].stringValue + " infomation"
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "", size: height * 0.1)
        title.backgroundColor = UIColor.whiteColor()
        title.textColor = ColorItem.getColor(index: editingCellIndex!.row)
        editingPanel!.addSubview(title)
        
        let textLabel: UILabel = UILabel(frame: CGRect(x: width * 0.1, y: height * 0.2, width: width * 0.2, height: height * 0.1))
        textLabel.text = "Title:"
        textLabel.textColor = UIColor.whiteColor()
        editingPanel!.addSubview(textLabel)
        
        let textField: UITextField = UITextField(frame: CGRect(x: width * 0.3 + 1, y: height * 0.2, width: width * 0.5, height: height * 0.1))
        textField.text = editingCellInfo!["title"].stringValue
        textField.backgroundColor = UIColor.whiteColor()
        textField.addTarget(self, action: "cellEditingTitleEdited:", forControlEvents: UIControlEvents.EditingChanged)
        textField.layer.cornerRadius = 2
        editingPanel!.addSubview(textField)
        
        let mouseLabel: UILabel = UILabel(frame: CGRect(x: width * 0.1, y: height * 0.4, width: width * 0.2, height: height * 0.1))
        mouseLabel.text = "Mouse:"
        mouseLabel.textColor = UIColor.whiteColor()
        editingPanel!.addSubview(mouseLabel)
        
        let mouseSwitch: UISwitch = UISwitch(frame: CGRect(x: width * 0.3 + 1, y: height * 0.4, width: width * 0.2, height: height * 0.1))
        if editingCellInfo!["mouse"].intValue == 1 {
            mouseSwitch.on = true
        }
        mouseSwitch.addTarget(self, action: "cellEditingMouseChanged:", forControlEvents: UIControlEvents.ValueChanged)
        editingPanel!.addSubview(mouseSwitch)
        
        let okButton: UIButton = UIButton(frame: CGRect(x: 0, y: height * 0.85, width: width * 0.5, height: height * 0.15))
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(ColorItem.getColor(index: editingCellIndex!.row), forState: UIControlState.Normal)
        okButton.setTitleColor(ColorItem.getColor(index: editingCellIndex!.row + 1), forState: UIControlState.Highlighted)
        okButton.backgroundColor = UIColor.whiteColor()
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.grayColor().CGColor
        okButton.addTarget(self, action: "cellEditingSured:", forControlEvents: UIControlEvents.TouchDown)
        editingPanel!.addSubview(okButton)
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x: width * 0.5, y: height * 0.85, width: width * 0.5, height: height * 0.15))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(ColorItem.getColor(index: editingCellIndex!.row), forState: UIControlState.Normal)
        cancelButton.setTitleColor(ColorItem.getColor(index: editingCellIndex!.row + 1), forState: UIControlState.Highlighted)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.grayColor().CGColor
        cancelButton.addTarget(self, action: "cellEditingCanceled:", forControlEvents: UIControlEvents.TouchDown)
        editingPanel!.addSubview(cancelButton)
    }
    
    func dismissCellEditingView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.editingPanel!.alpha = 0
            self.editingCover!.alpha = 0
            }) { (finished: Bool) -> Void in
                self.editingPanel!.removeFromSuperview()
                self.editingCover!.removeFromSuperview()
                self.editingPanel = nil
                self.editingCover = nil
        }
    }
    
    func cellEditingSured(sender: UIButton) {
        dismissCellEditingView()
    }
    
    func cellEditingCanceled(sender: UIButton) {
        dismissCellEditingView()
    }
    
    func cellEditingTitleEdited(sender: UITextField) {
        editingCellInfo!["title"].string = sender.text
    }
    
    func cellEditingMouseChanged(sender: UISwitch) {
        if sender.on {
            editingCellInfo!["mouse"].int = 1
        } else {
            editingCellInfo!["mouse"].int = 0
        }
    }
    
}

