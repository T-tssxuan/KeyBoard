
//
//  UIViewControllerPlay.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/7/28.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import QuartzCore

class UIViewControllerPlay: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var shapeBar: UICollectionView!
    var colorBar: UICollectionView!
    var shapeLabel: UILabel!
    var functionLabel: UILabel!
    var nameLabel: UILabel!
    var colorLabel: UILabel!
    var scaleLabel: UILabel!
    var scaleSlider: UISlider!
    var heightLabel: UILabel!
    var heightSlider: UISlider!
    var widthLabel: UILabel!
    var widthSlider: UISlider!
    var gobackButton: UIButton!
    var positionConfigureButton: UIButton!
    var functionConfigureButton: UIButton!
    var functionAlertController: UIAlertController!
    var OKButton: UIButton!
    var TitleConfigureButton: UIButton!
    var titleAlertController: UIAlertController!
    var BackgroundImageConfigureButton: UIButton!
    
    var menu: Menu!
    
    var customingKeyBoardButton: KeyBoardButton!
    
    var editCover: UIView!
    
    var configureHidden: Bool = false
    
    var orientation: Int? = 0
    var backgroundColor: UIColor? = UIColor.whiteColor()
    
    var buttonsInfo: JSON = ""
    var pageName: String!
    var customButtons: [String : KeyBoardButton] = [:]
    
    var playStatus: UInt = 0 // 0 normal, 1 add, 2 edit, 3 delete

    
    init(pageInfo: JSON, name pageName: String) {
        self.pageName = pageName
        orientation = pageInfo["orientation"].int
        println("the pageinfo: \(pageInfo)")
        buttonsInfo = pageInfo["keys"]
        backgroundColor = UIColor(
            red: CGFloat(pageInfo["backgroundcolor"][0].floatValue),
            green: CGFloat(pageInfo["backgroundcolor"][1].floatValue),
            blue: CGFloat(pageInfo["backgroundcolor"][2].floatValue),
            alpha: CGFloat(pageInfo["backgroundcolor"][3].floatValue)
        )
        println("before super")
        super.init(nibName: nil, bundle: nil)
        println("after super")
    }
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
//        var tap = UITapGestureRecognizer(target: self, action: "handleTap:")
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
        view.backgroundColor = backgroundColor
        loadKeyBoardButtons()
        
        println("view frame \(view.frame)")
        
        editCover = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.width))
        
        editCover.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        view.addSubview(editCover)
        
        setShapeBar()
        setColorBar()
        setStatusBar()
        setSizeWidget()
        
        setPositionConfigureButton()
        setFunctionConfigureButton()
        setTitleConfigureButton()
        setBackgroundImageConfigureButton()
        setGobackButton()
        setOKButton()
        
        playMode()
        
        setMenu()
        
        println("int didload")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if configureHidden {
            editMode(newButton: true)
        }
        
        println("configureHidden \(configureHidden)")
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        println("in orient")
        if (orientation == 0) {
            return UIInterfaceOrientation.LandscapeLeft
        } else {
            return UIInterfaceOrientation.Portrait
        }
    }
    
    func loadKeyBoardButtons() {
        println("\(buttonsInfo)")
        for (index: String, subJson: JSON) in buttonsInfo {
            println("a button")
            var button: KeyBoardButton = KeyBoardButton(frame: CGRectZero, host: self)
            button.setButtonInfo(info: buttonsInfo[index])
            customButtons[index] = button
            self.view.addSubview(button)
        }
    }
    
    func setMenu() {
        menu = Menu()
        view.addSubview(menu.pageMenu)
        view.addSubview(menu.pageAddButon)
        view.addSubview(menu.pageDismissButton)
        view.addSubview(menu.pageEditButton)
        view.addSubview(menu.pageSettingButton)
        
        var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "menuPan:")
        menu.pageMenu.addGestureRecognizer(pan)
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuTapped:")
        menu.pageMenu.addGestureRecognizer(pan)
        menu.pageMenu.addGestureRecognizer(tap)
        
        menu.pageDismissButton.addTarget(self, action: "menuDismissTapped:", forControlEvents: UIControlEvents.TouchDown)
        menu.pageAddButon.addTarget(self, action: "menuAddTapped:", forControlEvents: UIControlEvents.TouchDown)
        menu.pageEditButton.addTarget(self, action: "menuEditTapped:", forControlEvents: UIControlEvents.TouchDown)
        menu.pageSettingButton.addTarget(self, action: "menuSettingTapped:", forControlEvents: UIControlEvents.TouchDown)
    }
    
    func menuPan(sender: UIPanGestureRecognizer) {
        var point: CGPoint = sender.translationInView(sender.view!)
        println("int the menu gesture recognizer")
        menu.pageMenu.center = CGPointMake(menu.pageMenu.center.x + point.x, menu.pageMenu.center.y + point.y)
        println("frame \(menu.pageMenu.frame)")
        sender.setTranslation(CGPointZero, inView: sender.view)
        menu.updateMenuPosition()
    }
    
    func menuTapped(sender: UIButton) {
        menu.toggleMenuItems()
    }
    
    func menuDismissTapped(sender: UIButton) {
        var info: JSON = [:]
        info["orientation"].int = orientation
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        println("\(r, g, b, a)")
        info["backgroundcolor"] = [
            Float(r),
            Float(g),
            Float(b),
            Float(a)
        ]
        info["keys"] = buttonsInfo
        println("\(info)")
        InfoManager.setSubpageInformation(pageName: pageName, info: info)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func menuAddTapped(sender: UIButton) {
        if configureHidden {
            setCustomingKeyBoardBuuton()
            editMode(newButton: true)
            playStatus = 1
        } else {
            playStatus = 0
        }
    }
    
    func menuEditTapped(sender: UIButton) {
        if configureHidden {
            editMode(newButton: false)
            playStatus = 2
        } else {
            playStatus = 0
        }
    }
    
    func menuSettingTapped(sender: UIButton) {
        println("tap the menu setting button")
    }

    
    func setShapeBar() {
        var marginLeft: CGFloat = 0
        var marginTop: CGFloat = 30
        var width:CGFloat = 70
        var height:CGFloat = self.view.frame.width
        var itemSize: CGSize = CGSize(width: 70, height: 70)
        var itemEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = itemEdgeInsets
        shapeBar = UICollectionView(
            frame: CGRect(x: marginLeft, y: marginTop, width: width, height: height),
            collectionViewLayout: layout
        )
        shapeBar.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "shapeBar")
        shapeBar.dataSource = self
        shapeBar.delegate = self
        self.view.addSubview(shapeBar)
    }
    
    func setColorBar() {
        var marginLeft: CGFloat = self.view.frame.height - 50
        var marginTop: CGFloat = 30
        var width: CGFloat = 50
        var height: CGFloat = self.view.frame.width
        var itemSize: CGSize = CGSize(width: 50, height: 50)
        var itemEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = itemEdgeInsets
        colorBar = UICollectionView(
            frame: CGRect(x: marginLeft, y: marginTop, width: width, height: height),
            collectionViewLayout: layout
        )
        colorBar.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorBar")
        colorBar.dataSource = self
        colorBar.delegate = self
        self.view.addSubview(colorBar)
    }
    
    func setStatusBar() {
        var marginLeft: CGFloat = 0
        var marginTop: CGFloat = 0
        var height: CGFloat = 30
        var shapeLabelWidth: CGFloat = 70
        var colorLabelWidth: CGFloat = 50
        var statusLableTotalLength: CGFloat = self.view.frame.height - 70 - 50
        
        shapeLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: shapeLabelWidth,
                height: height
            )
        )
        marginLeft = marginLeft + shapeLabelWidth
        shapeLabel.backgroundColor = UIColor.blackColor()
        shapeLabel.text = "Shape"
        shapeLabel.font = UIFont(name: "", size: 15)
        shapeLabel.textColor = UIColor.whiteColor()
        shapeLabel.textAlignment = NSTextAlignment.Center
        
        functionLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: statusLableTotalLength * 2 / 3,
                height: height
            )
        )
        marginLeft = marginLeft + statusLableTotalLength * 2 / 3
        functionLabel.text = "Ctr + Alt + A"
        functionLabel.textAlignment = NSTextAlignment.Center
        functionLabel.font = UIFont(name: "", size: 20)
        functionLabel.textColor = UIColor.whiteColor()
        functionLabel.backgroundColor = UIColor.grayColor()

        nameLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: statusLableTotalLength / 3,
                height: height
            )
        )
        marginLeft = marginLeft + statusLableTotalLength / 3
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = "Name"
        nameLabel.font = UIFont(name: "", size: 20)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.backgroundColor = UIColor.grayColor()
        
        colorLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: colorLabelWidth,
                height: height
            )
        )
        colorLabel.text = "Color"
        colorLabel.backgroundColor = UIColor.blackColor()
        colorLabel.font = UIFont(name: "", size: 15)
        colorLabel.textColor = UIColor.whiteColor()
        colorLabel.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(shapeLabel)
        self.view.addSubview(functionLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(colorLabel)
    }
    
    func setSizeWidget() {
        var marginLeft: CGFloat = 75
        var marginRight: CGFloat = 55
        var marginTop: CGFloat = 35
        var height: CGFloat = 30
        var betweenGap: CGFloat = 5
        var totalWidth = self.view.frame.height - marginLeft - marginRight - betweenGap
        
        heightLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: totalWidth / 6,
                height: height
            )
        )
        marginLeft = marginLeft + totalWidth / 6
        heightLabel.textAlignment = NSTextAlignment.Center
        heightLabel.text = "height"
        heightLabel.backgroundColor = UIColor.grayColor()
        
        heightSlider = UISlider(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: totalWidth * 2 / 6,
                height: height
            )
        )
        marginLeft = marginLeft + totalWidth * 2 / 6 + 5
        heightSlider.minimumValue = 20
        heightSlider.maximumValue = 200
        heightSlider.value = 100
        heightSlider.backgroundColor = UIColor.grayColor()
        
        heightSlider.addTarget(self, action: "customButtonSizeChange:", forControlEvents: UIControlEvents.ValueChanged)
        
        widthLabel = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: totalWidth / 6,
                height: height
            )
        )
        marginLeft = marginLeft + totalWidth / 6
        widthLabel.textAlignment = NSTextAlignment.Center
        widthLabel.text = "width"
        widthLabel.backgroundColor = UIColor.grayColor()
        
        widthSlider = UISlider(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: totalWidth * 2 / 6,
                height: height
            )
        )
        widthSlider.minimumValue = 20
        widthSlider.maximumValue = 200
        widthSlider.value = 100
        widthSlider.backgroundColor = UIColor.grayColor()
        
        widthSlider.addTarget(self, action: "customButtonSizeChange:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(heightLabel)
        self.view.addSubview(heightSlider)
        self.view.addSubview(widthLabel)
        self.view.addSubview(widthSlider)
        
    }
    
    func setPositionConfigureButton() {
        var marginLeft: CGFloat = self.view.frame.height - 510
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image: UIImage = UIImage(named: "position")!
        
        positionConfigureButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        positionConfigureButton.layer.cornerRadius = radius
        positionConfigureButton.clipsToBounds = true
        positionConfigureButton.backgroundColor = UIColor.grayColor()
        positionConfigureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        positionConfigureButton.addTarget(self, action: "clickPosition:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(positionConfigureButton)
    }
    
    func setFunctionConfigureButton() {
        var marginLeft: CGFloat = self.view.frame.height - 430
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image:UIImage = UIImage(named: "function")!
        
        functionConfigureButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        functionConfigureButton.layer.cornerRadius = radius
        functionConfigureButton.clipsToBounds = true
        functionConfigureButton.backgroundColor = UIColor.grayColor()
        functionConfigureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        functionConfigureButton.addTarget(self, action: "clickFunction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(functionConfigureButton)
        
        functionAlertController = UIAlertController(
            title: "Set Function",
            message: "set the function of the button with the format \"key1,key2,key3\"",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        functionAlertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "function"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (paramAction: UIAlertAction!) in
            if let textFields = self.functionAlertController?.textFields {
                let theTextField = textFields as! [UITextField]
                var temp: String! = theTextField[0].text as String
                if let match = temp.rangeOfString( "^([^,]+\\,(.+\\,)*){0,1}[^,]+$", options: NSStringCompareOptions.RegularExpressionSearch){
                    self.customingKeyBoardButton.buttonFunction = theTextField[0].text
                    self.functionLabel.text = temp.stringByReplacingOccurrencesOfString(",", withString: " + ")
                } else {
                    println("error format")
                    theTextField[0].text = ""
                }
                
            }
            
            println("set function \(self.customingKeyBoardButton.buttonFunction)")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil)
        
        functionAlertController.addAction(confirmAction)
        functionAlertController.addAction(cancelAction)

    }
    
    func setTitleConfigureButton() {
        var marginLeft: CGFloat = self.view.frame.height - 350
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image: UIImage = UIImage(named: "title")!
        
        TitleConfigureButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        TitleConfigureButton.layer.cornerRadius = radius
        TitleConfigureButton.clipsToBounds = true
        TitleConfigureButton.backgroundColor = UIColor.grayColor()
        TitleConfigureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        TitleConfigureButton.addTarget(self, action: "clickTitle:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(TitleConfigureButton)
        titleAlertController = UIAlertController(
            title: "Set Title",
            message: "set the title of the button no more than two words",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        titleAlertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "button title"
        }
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (paramAction: UIAlertAction!) in
            if let textFields = self.titleAlertController?.textFields {
                let theTextField = textFields as! [UITextField]
                self.customingKeyBoardButton.buttonTitle = theTextField[0].text
                self.nameLabel.text = theTextField[0].text
            }
            
            println("set function \(self.customingKeyBoardButton.buttonTitle)")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil )
        
        titleAlertController.addAction(confirmAction)
        titleAlertController.addAction(cancelAction)

    }
    
    func setBackgroundImageConfigureButton() {
        var marginLeft: CGFloat = self.view.frame.height - 270
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image: UIImage = UIImage(named: "picture")!
        
        BackgroundImageConfigureButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        BackgroundImageConfigureButton.layer.cornerRadius = radius
        BackgroundImageConfigureButton.clipsToBounds = true
        BackgroundImageConfigureButton.backgroundColor = UIColor.grayColor()
        BackgroundImageConfigureButton.setBackgroundImage(image, forState: UIControlState.Normal)
        BackgroundImageConfigureButton.addTarget(self, action: "clickImage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(BackgroundImageConfigureButton)
    }
    
    func setGobackButton() {
        var marginLeft: CGFloat = self.view.frame.height - 190
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image: UIImage = UIImage(named: "back")!
        
        gobackButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        gobackButton.layer.cornerRadius = radius
        gobackButton.clipsToBounds = true
        gobackButton.backgroundColor = UIColor.grayColor()
        gobackButton.setBackgroundImage(image, forState: UIControlState.Normal)
        gobackButton.addTarget(self, action: "clickBack:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(gobackButton)
    }
    
    func setOKButton() {
        var marginLeft: CGFloat = self.view.frame.height - 110
        var marginTop: CGFloat = self.view.frame.width - 60
        var width: CGFloat = 50
        var height: CGFloat = 50
        var radius: CGFloat = 25
        var image: UIImage = UIImage(named: "ok")!
        
        OKButton = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: width,
                height: height
            )
        )
        OKButton.layer.cornerRadius = radius
        OKButton.clipsToBounds = true
        OKButton.backgroundColor = UIColor.grayColor()
        OKButton.setBackgroundImage(image, forState: UIControlState.Normal)
        OKButton.addTarget(self, action: "clickOk:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(OKButton)
    }
    
    func setCustomingKeyBoardBuuton() {
        var center: CGPoint = CGPoint(
            x: (self.view.frame.width - 120) / 2 + 20,
            y: (self.view.frame.height - 125) / 2 + 15
        )
        
        customingKeyBoardButton = KeyBoardButton(
            frame: CGRect(
                x: center.x,
                y: center.y,
                width: 100,
                height: 100
            ),
            host: self
        )
        
        customingKeyBoardButton.shapeCategory = ShapeCategory.Heart
        customingKeyBoardButton.buttonBackgroundImage = "default"
        self.view.addSubview(customingKeyBoardButton)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === shapeBar {
            return 10
        } else {
            return 9
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView === shapeBar {
            let cell = shapeBar.dequeueReusableCellWithReuseIdentifier("shapeBar", forIndexPath: indexPath) as! UICollectionViewCell
//            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            var content: ShapeItem = ShapeItem(
                frame:CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height),
                viewShape: indexPath.row
            )
            cell.contentView.addSubview(content)
            return cell
        } else {
            let cell = colorBar.dequeueReusableCellWithReuseIdentifier("colorBar", forIndexPath: indexPath) as! UICollectionViewCell
            cell.backgroundColor = ColorItem.getColor(index: indexPath.row)
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        println("high light \(indexPath.row)")
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        println("select item \(indexPath.row)")
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView === shapeBar {
            customingKeyBoardButton.shapeCategory = ShapeCategory(rawValue: indexPath.row % ShapeCategory.count)
            println("shape bar click")
        } else if collectionView === colorBar {
            customingKeyBoardButton.buttonBackgroundColor = indexPath.row
            println("color bar click")
        }
    }
    
    func customButtonSizeChange(slider: UISlider) {
        let center: CGPoint = CGPoint(
            x: (self.view.frame.width - 120) / 2 + 70,
            y: (self.view.frame.height - 125) / 2 + 65
        )
        
        println("this view frame \(view.frame)")
        
        let x: CGFloat = center.x - CGFloat(widthSlider.value / 2)
        let y: CGFloat = center.y - CGFloat(heightSlider.value / 2)
        let width: CGFloat = CGFloat(widthSlider.value)
        let height: CGFloat = CGFloat(heightSlider.value)
        
//        keyInformation["width"].float = Float(width)
//        keyInformation["height"].float = Float(height)
        
        customingKeyBoardButton.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    func clickBack(button: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        playMode()
        customingKeyBoardButton.removeFromSuperview()
        customingKeyBoardButton = nil
    }
    
    func clickOk(button: UIButton) {
        println("\(nameLabel.text)")
        customingKeyBoardButton.updateButtonInfo()
        buttonsInfo[customingKeyBoardButton.buttonTitle] = customingKeyBoardButton.buttonInfo
        if let keyButton = customButtons[customingKeyBoardButton.buttonTitle] {
            keyButton.setButtonInfo(info: customingKeyBoardButton.buttonInfo)
            customingKeyBoardButton.removeFromSuperview()
            customingKeyBoardButton = nil
        } else {
            customingKeyBoardButton.setButtonInfo(info: nil)
            customButtons[customingKeyBoardButton.buttonTitle] = customingKeyBoardButton
            customingKeyBoardButton = nil
        }
        playMode()
    }
    
    func clickFunction(button: UIButton) {
        self.presentViewController(functionAlertController, animated: true, completion: nil)
    }
    
    func clickImage(button: UIButton) {
        
    }
    
    func clickTitle(button: UIButton) {
        self.presentViewController(titleAlertController, animated: true, completion: nil)
    }
    
    func clickPosition(button: UIButton) {
        if configureHidden {
            showAllConfigureItem()
            customingKeyBoardButton.moveable = false
            customingKeyBoardButton.fromActualPositionToEditingPosition()
        } else {
            hiddenAllConfigureItem()
            customingKeyBoardButton.moveable = true
            positionConfigureButton.hidden = false
            customingKeyBoardButton.fromEditingPositionToActualPosition()
        }
    }
    
    func playMode() {
        hiddenAllConfigureItem()
        if let btn = customingKeyBoardButton {
            btn.hidden = true
        }
        editCover.hidden = true
    }
    
    func editMode(#newButton: Bool) {
        showAllConfigureItem()
        if newButton {
            editCover.hidden = false
            if let btn = customingKeyBoardButton {
                btn.hidden = false
            }
        }
    }
    
    func hiddenAllConfigureItem() {
        configureHidden = true
        shapeBar.hidden = true
        colorBar.hidden = true
        shapeLabel.hidden = true
        functionLabel.hidden = true
        nameLabel.hidden = true
        colorLabel.hidden = true
        heightLabel.hidden = true
        heightSlider.hidden = true
        widthLabel.hidden = true
        widthSlider.hidden = true
        gobackButton.hidden = true
        positionConfigureButton.hidden = true
        functionConfigureButton.hidden = true
        OKButton.hidden = true
        TitleConfigureButton.hidden = true
        BackgroundImageConfigureButton.hidden = true
    }
    
    func showAllConfigureItem() {
        configureHidden = false
        shapeBar.hidden = false
        colorBar.hidden = false
        shapeLabel.hidden = false
        functionLabel.hidden = false
        nameLabel.hidden = false
        colorLabel.hidden = false
        heightLabel.hidden = false
        heightSlider.hidden = false
        widthLabel.hidden = false
        widthSlider.hidden = false
        gobackButton.hidden = false
        positionConfigureButton.hidden = false
        functionConfigureButton.hidden = false
        OKButton.hidden = false
        TitleConfigureButton.hidden = false
        BackgroundImageConfigureButton.hidden = false
    }
    
    func toggleAllConfigureItem() {
        configureHidden = !configureHidden
        shapeBar.hidden = !shapeBar.hidden
        colorBar.hidden = !colorBar.hidden
        shapeLabel.hidden = !shapeLabel.hidden
        functionLabel.hidden = !functionLabel.hidden
        nameLabel.hidden = !nameLabel.hidden
        colorLabel.hidden = !colorLabel.hidden
        heightLabel.hidden = !heightLabel.hidden
        heightSlider.hidden = !heightSlider.hidden
        widthLabel.hidden = !widthLabel.hidden
        widthSlider.hidden = !widthSlider.hidden
        gobackButton.hidden = !gobackButton.hidden
        positionConfigureButton.hidden = !positionConfigureButton.hidden
        functionConfigureButton.hidden = !functionConfigureButton.hidden
        OKButton.hidden = !OKButton.hidden
        TitleConfigureButton.hidden = !TitleConfigureButton.hidden
        BackgroundImageConfigureButton.hidden = !BackgroundImageConfigureButton.hidden
    }
    
    func deleteKey(customKey key: KeyBoardButton) {
        key.removeFromSuperview()
        key.hidden = true
        customButtons.removeValueForKey(key.buttonTitle)
        buttonsInfo.dictionaryObject?.removeValueForKey(key.buttonTitle)
    }
    
    func editKey(customKey key: KeyBoardButton) {
        setCustomingKeyBoardBuuton()
        customingKeyBoardButton.setButtonInfo(info: key.buttonInfo)
        customingKeyBoardButton.updateButtonInfo()
    }
}

