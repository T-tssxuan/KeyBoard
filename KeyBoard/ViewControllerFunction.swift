////
////  ViewControllerFunction.swift
////  KeyBoard
////
////  Created by 罗玄 on 15/8/17.
////  Copyright (c) 2015年 罗玄. All rights reserved.
////
//
//import UIKit
//
//class ViewControllerFunction: UIViewController {
//    var orientation: Int? = 0
//    var backgroundColor: UIColor? = UIColor.whiteColor()
//    var keys: JSON?
//    
//    init(pageInfo: JSON) {
//        orientation = pageInfo["orientation"].int
//        println("the pageinfo: \(pageInfo)")
//        keys = pageInfo["keys"]
//        backgroundColor = UIColor(
//            red: CGFloat(pageInfo["backgroundcolor"][0].floatValue),
//            green: CGFloat(pageInfo["backgroundcolor"][1].floatValue),
//            blue: CGFloat(pageInfo["backgroundcolor"][2].floatValue),
//            alpha: CGFloat(pageInfo["backgroundcolor"][3].floatValue)
//        )
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var tap = UITapGestureRecognizer(target: self, action: "handleTap:")
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
//        view.backgroundColor = backgroundColor
//        loadKeyBoardButtons()
//        println("blabal")
//        var test: UIView = UIView(frame: self.view.frame)
//        test.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
//        view.addSubview(test)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func handleTap(sender: UITapGestureRecognizer) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        if (orientation == 0) {
//            return UIInterfaceOrientation.LandscapeLeft
//        } else {
//            return UIInterfaceOrientation.Portrait
//        }
//    }
//    
//    func loadKeyBoardButtons() {
//        println("\(keys)")
//        for (index: String, subJson: JSON) in keys! {
//            println("a button")
//            var key: KeyBoardButton = KeyBoardButton()
//            key.shapeCategory =  ShapeCategory.getCategory(index: subJson["shape"].intValue)
//            key.buttonBackgroundColor = subJson["color"].intValue
//            key.frame = CGRect(
//                x: subJson["x"].intValue,
//                y: subJson["y"].intValue,
//                width: subJson["width"].intValue,
//                height: subJson["height"].intValue
//            )
//            key.buttonTitle = subJson["title"].stringValue
//            key.buttonFunction = subJson["function"].stringValue
//            self.view.addSubview(key)
//        }
//    }
//    
//}
