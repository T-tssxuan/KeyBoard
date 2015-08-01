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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(setStatusBarBackgroundView())
        home =  HomePage()
        collectionView = home!.getHomeView()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return home!.getCellAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var page = UIViewControllerPlay()
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        self.presentViewController(UIViewControllerPlay(), animated: true, completion: nil)
    }
}

