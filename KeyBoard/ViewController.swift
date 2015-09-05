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
    
    // record the info of the cell which is editing in the homepage
    var editingCellIndex: NSIndexPath?
    var editingStatus: Bool! = false
    var editingPreSubviews: [AnyObject]!
    var editingCellInfo: JSON? = nil
    
    // for manuplate a cell in the homepage
    var editCellBtn: UIButton!
    var deleteCellBtn: UIButton!
    var okCellBtn: UIButton!
    var cancelCellBtn: UIButton!
    
    // the info for editing the detail info of the homepage
    var editingCover: UIView?
    var editingPanel: UIView?
    var editingIconGallery: UICollectionView?
    var editingIconGallerySelectedIndex: NSIndexPath? = nil
    var editingIconGallerySelectedCover: UIView!
    
    var addCellCover: UIView?
    var addCellPanel: UIView?
    var addCellTemplates: UICollectionView?
    var addCellTemplateSelectedIndex: NSIndexPath?
    var addCellTemplateSelectedCover: UIView!
    
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
        
        if editingStatus! {
            editingStatus = false
            changeCellToNormalMode()
        }
        
        let p = gestureRecognizer.locationInView(collectionView)
        editingCellIndex = collectionView.indexPathForItemAtPoint(p)
        
        if editingCellIndex?.row == 0 || editingCellIndex?.row == InfoManager.getHomeSetting().count - 1 {
            return
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
            itemInfo["image"] = "Signal"
        } else {
            itemInfo["image"] = "Signal_disable"
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
        if collectionView == self.collectionView {
            return home!.getCellAtIndexPath(indexPath)
        } else if editingIconGallery != nil && collectionView == editingIconGallery{
            return home!.getGalleryCellAtIndexPath(indexPath)
        } else {
            return home!.getTemplateAtIndexPath(indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("the number \(InfoManager.getHomeSetting().count)")
        if collectionView == self.collectionView {
            return InfoManager.getHomeSetting().count
        } else if editingIconGallery != nil && collectionView == editingIconGallery {
            return InfoManager.getFunctionIconNumer()
        } else {
            return InfoManager.getCellTemplate().count
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.collectionView {
            if editingStatus! {
                return
            }
            
            println("subpage setting \(InfoManager.appInfo!)")
            println("\(InfoManager.getHomeSetting().count) index \(indexPath.row)")
            if indexPath.row != InfoManager.getHomeSetting().count - 1 && indexPath.row != 0{
                let item: JSON = InfoManager.getHomeItemInformation(index: indexPath.row)
                let pageTitle: String = item["title"].stringValue
                var mouseEnable: Bool = false
                if item["mouse"] == 1 {
                    mouseEnable = true
                }
                println("subpage info: \(pageTitle)")
                let pageInfo = InfoManager.getSubpageInformation(pageName: pageTitle)
                self.presentViewController(UIViewControllerPlay(pageInfo: pageInfo, name: pageTitle, mouse: mouseEnable), animated: true, completion: nil)
            } else if indexPath.row == 0 {
                self.presentViewController(NetworkViewController(), animated: true, completion: { () -> Void in
                    NetworkManager.sharedInstance.connect()
                })
            } else if indexPath.row == InfoManager.getHomeSetting().count - 1 {
                addCellCover = UIView(frame: UIScreen.mainScreen().bounds)
                addCellCover!.backgroundColor = UIColor.whiteColor()
                addCellCover!.alpha = 0
                view.addSubview(addCellCover!)
                
                addCellPanel = UIView(
                    frame: CGRect(
                        x: 0,
                        y: UIScreen.mainScreen().bounds.height * 0.2,
                        width: UIScreen.mainScreen().bounds.width,
                        height: UIScreen.mainScreen().bounds.height * 0.5
                    )
                )
                addCellPanel!.alpha = 0
                configureAddCellPanel()
                view.addSubview(addCellPanel!)
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.addCellCover!.alpha = 0.4
                    self.addCellPanel!.alpha = 1
                })
            }
        } else if editingIconGallery != nil && collectionView == editingIconGallery {
            if editingIconGallerySelectedIndex != nil {
                if let cover = editingIconGallerySelectedCover {
                    cover.removeFromSuperview()
                }
            }
            editingIconGallerySelectedIndex = indexPath
            let cell = editingIconGallery?.cellForItemAtIndexPath(editingIconGallerySelectedIndex!)
            editingIconGallerySelectedCover = UIView(frame: cell!.contentView.frame)
            editingIconGallerySelectedCover.backgroundColor = UIColor.whiteColor()
            editingIconGallerySelectedCover.alpha = 0.3
            cell?.contentView.addSubview(editingIconGallerySelectedCover)
            editingCellInfo!["image"].string = InfoManager.getFunctionIconAtIdex(index: indexPath.row)
        } else {
            if addCellTemplateSelectedIndex != nil {
                if let cover = addCellTemplateSelectedCover {
                    cover.removeFromSuperview()
                }
            }
            addCellTemplateSelectedIndex = indexPath
            let cell = addCellTemplates?.cellForItemAtIndexPath(addCellTemplateSelectedIndex!)
            addCellTemplateSelectedCover = UIView(frame: cell!.contentView.frame)
            addCellTemplateSelectedCover.backgroundColor = UIColor.whiteColor()
            addCellTemplateSelectedCover.alpha = 0.3
            cell?.contentView.addSubview(addCellTemplateSelectedCover)
        }
        
//        NetworkManager.sharedInstance.send(msg: "abc")
        println("the deselect index is: \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("the select index is: \(indexPath.row)")
    }
    
    // for the long press trigger the manuplate the cell
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
        let editCellBtnTemp: UIButton = self.editCellBtn
        let deleteCellBtnTemp: UIButton = self.deleteCellBtn
        let okCellBtnTemp: UIButton = self.okCellBtn
        let cancelCellBtnTemp: UIButton = self.cancelCellBtn
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            editCellBtnTemp.frame = CGRect(x: -width, y: -height, width: width, height: height)
            deleteCellBtnTemp.frame = CGRect(x: width + width, y: -height, width: width, height: height)
            okCellBtnTemp.frame = CGRect(x: -width, y: height + height, width: width, height: height)
            cancelCellBtnTemp.frame = CGRect(x: width + width, y: height + height, width: width, height: height)
            editCellBtnTemp.alpha = 0
            deleteCellBtnTemp.alpha = 0
            okCellBtnTemp.alpha = 0
            cancelCellBtnTemp.alpha = 0
            }) { (finished: Bool) -> Void in
                editCellBtnTemp.removeFromSuperview()
                deleteCellBtnTemp.removeFromSuperview()
                okCellBtnTemp.removeFromSuperview()
                cancelCellBtnTemp.removeFromSuperview()
        }
    }
    
    
    // for manuplate the info of the selected cell
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
        InfoManager.removeHomeSettingAtIndex(editingCellIndex!.row)
        self.home!.updateHomeInfo()
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.deleteItemsAtIndexPaths([self.editingCellIndex!])
            self.collectionView.reloadSections(NSIndexSet(index: 0))
        }, completion: nil)
        
        editingCellIndex = nil
        editingPreSubviews = []
        editingStatus = false
    }
    
    func okCellBtnClick(sender: UIButton) {
        editingStatus = false
        println("editing cell info \(editingCellInfo)")
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
    
    // for the editing cell info
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
            mouseSwitch.on
                = true
        }
        mouseSwitch.addTarget(self, action: "cellEditingMouseChanged:", forControlEvents: UIControlEvents.ValueChanged)
        editingPanel!.addSubview(mouseSwitch)
        
        let imageLable: UILabel = UILabel(frame: CGRect(x: width * 0.1, y: height * 0.6, width: width * 0.2, height: height * 0.1))
        imageLable.text = "Image:"
        imageLable.textColor = UIColor.whiteColor()
        editingPanel!.addSubview(imageLable)
        
        editingIconGallery = home!.getGalleryView(width: width * 0.2, galleryFrame: CGRect(x: width * 0.3, y: height * 0.6, width: width * 0.6, height: height * 0.2))
        editingIconGallery!.dataSource = self
        editingIconGallery!.delegate = self
        editingPanel!.addSubview(editingIconGallery!)
        
        
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
        editingCellInfo = nil
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
    
    
    // for add new cell
    func configureAddCellPanel() {
        let width = addCellPanel!.frame.width
        let height = addCellPanel!.frame.height
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height * 0.1))
        title.text = "Please select the template"
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "", size: height * 0.1)
        title.backgroundColor = UIColor.whiteColor()
        title.textColor = ColorItem.getColor(index: 0)
        addCellPanel!.addSubview(title)
        
        addCellTemplates = home!.getTemplateView(
            width: width / 2,
            templateFrame: CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.75)
        )
        addCellTemplates!.dataSource = self
        addCellTemplates!.delegate = self
        addCellPanel!.addSubview(addCellTemplates!)
        
        let okButton: UIButton = UIButton(frame: CGRect(x: 0, y: height * 0.85, width: width * 0.5, height: height * 0.15))
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(ColorItem.getColor(index: 0), forState: UIControlState.Normal)
        okButton.setTitleColor(ColorItem.getColor(index: 1), forState: UIControlState.Highlighted)
        okButton.backgroundColor = UIColor.whiteColor()
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.grayColor().CGColor
        okButton.addTarget(self, action: "addNewCell:", forControlEvents: UIControlEvents.TouchDown)
        addCellPanel!.addSubview(okButton)
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x: width * 0.5, y: height * 0.85, width: width * 0.5, height: height * 0.15))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(ColorItem.getColor(index: 0), forState: UIControlState.Normal)
        cancelButton.setTitleColor(ColorItem.getColor(index: 1), forState: UIControlState.Highlighted)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.grayColor().CGColor
        cancelButton.addTarget(self, action: "cancelAddNewCell:", forControlEvents: UIControlEvents.TouchDown)
        addCellPanel!.addSubview(cancelButton)
    }
    
    func addNewCell(sender: UIButton) {
        if addCellTemplateSelectedIndex != nil {
            InfoManager.addHomeSetting(addCellTemplateSelectedIndex!.row)
            home!.updateHomeInfo()
            let endIndex = InfoManager.getHomeSetting().count - 2
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: endIndex, inSection: 0)])
            collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: endIndex + 1, inSection: 0)])
        }
        dismissAddCellView()
    }
    
    func cancelAddNewCell(sender: UIButton) {
        dismissAddCellView()
    }
    
    func dismissAddCellView() {
        addCellTemplateSelectedIndex = nil
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.addCellPanel!.alpha = 0
            self.addCellCover!.alpha = 0
            }) { (finished: Bool) -> Void in
                self.addCellPanel!.removeFromSuperview()
                self.addCellCover!.removeFromSuperview()
                self.addCellPanel = nil
                self.addCellCover = nil
        }
    }
    
}

