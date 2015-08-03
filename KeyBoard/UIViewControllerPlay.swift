
//
//  UIViewControllerPlay.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/7/28.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import QuartzCore

class UIViewControllerPlay: UIViewController, UICollectionViewDataSource {
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
    var colorMap : Dictionary<Int, UIColor?>?
    var gobackButton: UIButton!
    var positionConfigureButton: UIButton!
    var functionConfigureButton: UIButton!
    var OKButton: UIButton!
    var TitleConfigureButton: UIButton!
    var BackgroundImageConfigureButton: UIButton!
    
    var customingKeyBoardButton: KeyBoardButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorMap = [
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
        view.backgroundColor = UIColor.whiteColor()
        
        var tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
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
        setCustomingKeyBoardBuuton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
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
        heightSlider.value = 50
        heightSlider.backgroundColor = UIColor.grayColor()
        
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
        widthSlider.value = 50
        widthSlider.backgroundColor = UIColor.grayColor()
        
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
        self.view.addSubview(functionConfigureButton)

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
        self.view.addSubview(TitleConfigureButton)
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
        self.view.addSubview(OKButton)
    }
    
    func setCustomingKeyBoardBuuton() {
        var center: CGPoint = CGPoint(
            x: (self.view.frame.height - 120) / 2,
            y: (self.view.frame.width - 120) / 2
        )
        customingKeyBoardButton = KeyBoardButton(
            frame: CGRect(
                x: center.x,
                y: center.y,
                width: 100,
                height: 100
            )
        )
//        customingKeyBoardButton.backgroundColor = UIColor.grayColor()
//        customingKeyBoardButton.setNeedsDisplay()
//        customingKeyBoardButton.setTitle("custom", forState: UIControlState.Normal)
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
            cell.backgroundColor = colorMap![(indexPath.row % 10)]!
            return cell
        }
    }
    
}

