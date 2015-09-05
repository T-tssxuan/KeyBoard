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
    var homeInfo: JSON = InfoManager.getHomeSetting()
    var gallery: UICollectionView!
    var template: UICollectionView!
    var templateInfo: JSON = InfoManager.getCellTemplate()["home"]
    
    override init(){
        super.init()
        let layout = UICollectionViewFlowLayout()
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
    
    func updateHomeInfo() {
        homeInfo = InfoManager.getHomeSetting()
    }
    
    func getHomeView() -> UICollectionView! {
        return homeCollectionView
    }
        
    func getCellAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCellWithReuseIdentifier("HomePageCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = ColorItem.getColor(index: indexPath.row)
        cell.contentView.subviews.map{ $0.removeFromSuperview() }
        cell.contentView.addSubview(
            getCellContentViewAtIndexPath(
                cellIndexPath: indexPath,
                cellSize: CGSize(width: cell.frame.width, height: cell.frame.height),
                source: homeInfo
            )
        )
        
        return cell
    }
    
    func getCellContentViewAtIndexPath(cellIndexPath indexPath: NSIndexPath, cellSize size: CGSize, source info: JSON)->UIView{
        var contentView: UIView!
        var label: UILabel!
        var image: UIImage!
        var imageView: UIImageView
        var imageName: String = "KeyBoard"
        var textContent: String = "KeyBoard"
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        println("homeinfo : \(indexPath.row)")
        println("homeinfo : \( info[indexPath.row])")
        println("homeinfo : \(info)")
        imageName = info[indexPath.row]["image"].string!
        textContent = info[indexPath.row]["title"].string!
        
        image = UIImage(named: imageName)!
        imageView = UIImageView(image: image)
        var rate:CGFloat = 3 / 7
        imageView.frame = CGRect(x: size.width * 2 / 7, y: size.height / 7, width: size.width * rate, height: size.height * rate)
        contentView.addSubview(imageView)
        label = UILabel(frame: CGRect(x: size.width * 4 / 14, y: size.height * 3 / 7, width: size.width * rate, height: size.height * rate))
        label.text = textContent
//        label.font = UIFont(name: "Arial Black", size: 25)
        label.textColor = UIColor.whiteColor()
        label.sizeThatFits(CGSize(width: label.frame.width, height: label.frame.height))
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        return contentView
    }
    
    func getGalleryView(#width: CGFloat, galleryFrame frame: CGRect) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: width,
            height: width
        )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        gallery = UICollectionView(frame: frame, collectionViewLayout: layout)
        gallery.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "galleryCell")
        return gallery
    }
    
    func getGalleryCellAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = gallery.dequeueReusableCellWithReuseIdentifier("galleryCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = ColorItem.getColor(index: indexPath.row)
        cell.contentView.subviews.map{ $0.removeFromSuperview() }
        println("\(InfoManager.getFunctionIconAtIdex(index: indexPath.row))")
        let image: UIImage = UIImage(named: InfoManager.getFunctionIconAtIdex(index: indexPath.row))!
        let imageView: UIImageView = UIImageView(frame: cell.contentView.frame)
        imageView.image = image
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func getTemplateView(#width: CGFloat, templateFrame frame: CGRect) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: width,
            height: width
        )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        template = UICollectionView(frame: frame, collectionViewLayout: layout)
        template.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "templateCell")
        return template
    }
    
    func getTemplateAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = template.dequeueReusableCellWithReuseIdentifier("templateCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = ColorItem.getColor(index: indexPath.row)
        cell.contentView.subviews.map{ $0.removeFromSuperview() }
        cell.addSubview(
            getCellContentViewAtIndexPath(
                cellIndexPath: indexPath,
                cellSize: CGSize(width: cell.frame.width, height: cell.frame.height),
                source: templateInfo
            )
        )
        return cell
    }

}
