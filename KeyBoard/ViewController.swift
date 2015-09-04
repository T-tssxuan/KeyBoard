//
//  ViewController.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/7/26.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var home: HomePage?
    var collectionView: UICollectionView!
    var appInfo: [String: AnyObject]!
    
    var editingCellIndex: NSIndexPath?
    var editingStatus: Bool! = false
    var editingPreSubviews: [AnyObject]!
    
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
        
        var itemInfo: JSON = InfoManager.getHomeSettingAtIndex(1)
        itemInfo["title"].string = info
        if info == "connected" {
            itemInfo["image"] = "signal"
        } else {
            itemInfo["image"] = "signal_disable"
        }
        
        InfoManager.setHomeSettingAtIndex(1, info: itemInfo)
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
        return InfoManager.getHomeSetting().count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editingStatus! {
            return
        }
        
        if indexPath.row != InfoManager.getHomeSetting().count - 1 && indexPath.row != 0{
            let item: JSON = InfoManager.getHomeItemInformation(index: indexPath.row + 1)
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
    
    func changeCellToEditMode() {
        let editingCell = collectionView.cellForItemAtIndexPath(editingCellIndex!)
        editingPreSubviews = editingCell?.contentView.subviews
//        editingCell!.contentView.subviews.map {$0.removeFromSuperview()}
        println("view numbers: \(editingCell!.contentView.subviews.count)")
        let width = editingCell!.contentView.frame.width / 2
        let height = editingCell!.contentView.frame.height / 2
        
        let editCellBtn: UIButton = UIButton(frame: CGRect(x: -width, y: -height, width: width, height: height))
        editCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row)
        editCellBtn.setTitle("Edit", forState: UIControlState.Normal)
        editCellBtn.addTarget(self, action: "editCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(editCellBtn)
        
        let deleteCellBtn: UIButton = UIButton(frame: CGRect(x: width + width, y: -height, width: width, height: height))
        deleteCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 1)
        deleteCellBtn.setTitle("Delete", forState: UIControlState.Normal)
        deleteCellBtn.addTarget(self, action: "deleteCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(deleteCellBtn)
        
        let okCellBtn: UIButton = UIButton(frame: CGRect(x: -width, y: height + height, width: width, height: height))
        okCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 2)
        okCellBtn.setTitle("Ok", forState: UIControlState.Normal)
        okCellBtn.addTarget(self, action: "okCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(okCellBtn)
        
        let cancelCellBtn: UIButton = UIButton(frame: CGRect(x: width + width, y: height + height, width: width, height: height))
        cancelCellBtn.backgroundColor = ColorItem.getColor(index: editingCellIndex!.row + 3)
        cancelCellBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelCellBtn.addTarget(self, action: "cancelCellBtnClick:", forControlEvents: UIControlEvents.TouchDown)
        editingCell!.contentView.addSubview(cancelCellBtn)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            editCellBtn.frame = CGRect(x: 0, y: 0, width: width, height: height)
            deleteCellBtn.frame = CGRect(x: width, y: 0, width: width, height: height)
            okCellBtn.frame = CGRect(x: 0, y: height, width: width, height: height)
            cancelCellBtn.frame = CGRect(x: width, y: height, width: width, height: height)
        })
    }
    
    func changeCellToNormalMode() {
        var cell = collectionView.cellForItemAtIndexPath(editingCellIndex!)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for view in cell!.contentView.subviews {
                if view as! UIView != self.editingPreSubviews[0] as! UIView {
                    view.removeFromSuperview()
                }
            }
        })
    }
    
    func editCellBtnClick(sender: UIButton) {
        
    }
    
    func deleteCellBtnClick(sender: UIButton) {
        println("the editingCellIndex \(editingCellIndex)")
        let homeInfo = InfoManager.getHomeSetting()
        var arr: [AnyObject] = []
        for var i = 0; i < homeInfo.count; i += 1 {
            if i != editingCellIndex?.row {
                arr.append(homeInfo[i].dictionaryValue as! AnyObject)
            }
        }
        var re: JSON!
        re.arrayObject = arr
        InfoManager.setHomeSetting(homeSeting: re)
        
        collectionView.deleteItemsAtIndexPaths([editingCellIndex!])
        editingCellIndex = nil
        editingPreSubviews = []
        editingStatus = false
    }
    
    func okCellBtnClick(sender: UIButton) {
        editingStatus = false
        changeCellToNormalMode()
    }
    
    func cancelCellBtnClick(sender: UIButton) {
        editingStatus = false
        changeCellToNormalMode()
    }
    
}

