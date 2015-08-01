//
//  HomePage.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/7/26.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import Foundation

class HomePage:NSObject {

    var homeCollectionView: UICollectionView!
    var colorMap : Dictionary<Int, UIColor?>?
    
    override init(){
        super.init()
        let layout = UICollectionViewFlowLayout()
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
        switch UIDevice.currentDevice().orientation {
        case UIDeviceOrientation.Portrait, UIDeviceOrientation.PortraitUpsideDown, UIDeviceOrientation.Unknown:
            layout.itemSize = CGSize(
                width: UIScreen.mainScreen().bounds.width / 2,
                height: (UIScreen.mainScreen().bounds.height - 20) / 4
            )
        default:
            layout.itemSize = CGSize(
                width: (UIScreen.mainScreen().bounds.width - 20) / 4,
                height: UIScreen.mainScreen().bounds.height / 2
            )
        }
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var frame = CGRect(x: 0, y: 20,
            width: UIScreen.mainScreen().bounds.width,
            height: UIScreen.mainScreen().bounds.height - 20)
        homeCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        homeCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "HomePageCell")
        print("nothing")
    }
    
    func getHomeView() -> UICollectionView! {
        return homeCollectionView
    }
        
    func getCellAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCellWithReuseIdentifier("HomePageCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = colorMap![(indexPath.row % 10)]!
        cell.contentView.addSubview(getCellContentViewAtIndexPath(
            cellIndexPath: indexPath,
            cellSize: CGSize(width: cell.frame.width, height: cell.frame.height))
        )
        
        return cell

    }
    
    func getCellContentViewAtIndexPath(cellIndexPath indexPath: NSIndexPath, cellSize size: CGSize)->UIView{
        var contentView: UIView!
        var label: UILabel!
        var image: UIImage!
        var imageView: UIImageView
        var imageName: String = "KeyBoard"
        var textContent: String = "KeyBoard"
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        if indexPath.row == 0 {
            imageName = "Signal"
            textContent = "Signal"
        }
        if indexPath.row == 1 {
            imageName = "KeyBoard"
            textContent = "KeyBoard"
        }
        if indexPath.row == 2 {
            imageName = "Handle"
            textContent = "Handle"
        }
        if indexPath.row == 3 {
            imageName = "Mouse"
            textContent = "Mouse"
        }
        if indexPath.row == 7{
            imageName = "Add"
            textContent = "Add New"
        }
        image = UIImage(named: imageName)!
        imageView = UIImageView(image: image)
        var rate:CGFloat = 3 / 7
        imageView.frame = CGRect(x: size.width * 2 / 7, y: size.height / 7, width: size.width * rate, height: size.height * rate)
        contentView.addSubview(imageView)
        label = UILabel(frame: CGRect(x: size.width * 4 / 14, y: size.height * 3 / 7, width: size.width * rate, height: size.height * rate))
        
        label.text = textContent
        label.font = UIFont(name: "Arial Black", size: 25)
        label.textColor = UIColor.whiteColor()
        label.sizeThatFits(CGSize(width: label.frame.width, height: label.frame.height))
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        return contentView
        
    }


}
