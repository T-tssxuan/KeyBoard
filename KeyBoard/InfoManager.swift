//
//  InfoManager.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/10.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit


class InfoManager: NSObject {
    static var fileManager: NSFileManager? = nil
    static var appInfo: JSON? = nil
    static var documentsDirectoryPath: String!
    static var configuration: String = "configuration"

    static let homeSetingDefault: JSON = [
        "index": 0,
        "backgroundcolor": 0,
        "title": "New",
        "image": "KeyBoard",
        "editable": false,
        "function": 1,
        "subpage": "",
        "mouse": 0
    ]
    
    static let subpageSetingDefault: JSON = [
        "backgroundcolor": [0.2, 0.3, 0.5, 1],
        "orientation": 0,
        "keys": []
    ]
    
    static let functionIconSet: [String] = [
        "Mouse",
        "KeyBoard",
        "Handle",
        "Signal"
    ]
    
    static func initPath() {
        if documentsDirectoryPath == nil {
            fileManager = NSFileManager.defaultManager()
            var directoryPaths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.LibraryDirectory,
                NSSearchPathDomainMask.UserDomainMask,
                true
            )
            documentsDirectoryPath = directoryPaths[0] as? String
            documentsDirectoryPath = documentsDirectoryPath.stringByAppendingPathComponent(configuration)
            println("the paths are \(documentsDirectoryPath)")
            if !(fileManager?.fileExistsAtPath(documentsDirectoryPath) != nil) {
                println("file dosen't exist")
                fileManager!.createFileAtPath(documentsDirectoryPath, contents: nil, attributes: nil)
            }
        }
    }
    
    static func initData() {
//        println("log appInfo \(appInfo)")
        if appInfo == nil {
            initPath()
            println("after initpath")
            if let info = NSData(contentsOfFile: documentsDirectoryPath) {
//                println("content of file \(info)")
                appInfo = JSON(data:info)
            }
//            println("the info \(appInfo)")
        }
    }
    
    static func initFirstData() -> JSON {
        var info: JSON = [
            "ip": "127.0.0.1",
            "home":
            [
                [
                    "index": 0,
                    "backgroundcolor": 1,
                    "title": "Signal",
                    "image": "Signal",
                    "editable": false,
                    "function": 0,
                    "subpage": "",
                    "mouse": 0
                ],
                [
                    "index": 1,
                    "backgroundcolor": 1,
                    "title": "KeyBoard",
                    "image": "KeyBoard",
                    "editable": false,
                    "function": 0,
                    "subpage": "keyboard",
                    "mouse": 0
                ],
                [
                    "index": 2,
                    "backgroundcolor": 2,
                    "title": "Handle",
                    "image": "Handle",
                    "editable": false,
                    "function": 0,
                    "subpage": "handle",
                    "mouse": 0
                ],
                [
                    "index": 3,
                    "backgroundcolor": 3,
                    "title": "Mouse",
                    "image": "Mouse",
                    "editable": false,
                    "function": 0,
                    "subpage": "mouse",
                    "mouse": 1
                ],
                [
                    "index": 4,
                    "backgroundcolor": 0,
                    "title": "Add New",
                    "image": "Add",
                    "editable": false,
                    "function": 1,
                    "subpage": "",
                    "mouse": 0
                ]
            ],
            "subpage":
            [
                "KeyBoard":
                [
                    "backgroundcolor": [0.2, 0.3, 0.5, 1],
                    "orientation": 0,
                    "keys":
                    [
                        "a":
                        [
                            "x": 50,
                            "y": 50,
                            "width": 100,
                            "height": 100,
                            "shape": 3,
                            "color": 0,
                            "title": "a",
                            "image": 0,
                            "function": "a,b,c"
                        ]
                    ]
                ],
                "Handle":
                [
                    "backgroundcolor": [0.5, 0.4, 0.9, 1],
                    "orientation": 0,
                    "keys":
                    [
                        "a":
                        [
                            "x": 0,
                            "y": 0,
                            "width": 100,
                            "height": 100,
                            "shape": 2,
                            "color": 0,
                            "title": "a",
                            "image": 0,
                            "function": "a,b,c"
                        ]
                    ]
                ],
                "Mouse":
                [
                    "backgroundcolor": [0.3, 0.8, 0.9, 1],
                    "orientation": 0,
                    "keys":
                    [
                        "a":
                        [
                            "x": 30,
                            "y": 30,
                            "width": 100,
                            "height": 100,
                            "shape": 0,
                            "color": 0,
                            "title": "a",
                            "image": 0,
                            "function": "a,b,c"
                        ]
                    ]
                ],

            ]
        ]
//        var tow = JSON(data: info.rawData(options: nil, error: nil)!)
//        println("before remove: \(tow)")
//        tow.dictionaryObject?.removeValueForKey("subpage")
//        println("the subpage : \(tow)")
        return info
    }
    
    static func saveItems() {
        println("write appItem appInfo: \(appInfo)")
//        appInfo = initFirstData()
//        initFirstData()
        initPath()
        println("the json data: \(appInfo)")
        var data: NSData! = appInfo!.rawData()
        println("json data: \(data)")
        var re: Bool = data!.writeToFile(documentsDirectoryPath!, atomically: true)
        println("result of write \(re)")
    }
    
    static func getItems() -> JSON {
        initData()
        var temp = appInfo!["home"]
        println("The home \(temp)")
        return appInfo!
    }
    
    static func getHomeSetting() -> JSON {
        initData()
        return appInfo!["home"] as JSON
    }
    
    static func setHomeSetting(#homeSeting: JSON) {
        println("the home setting \(homeSeting)")
        appInfo!["home"] = homeSeting
    }
    
    static func getHomeSettingAtIndex(index: Int) -> JSON {
        initData()
        return appInfo!["home"][index] as JSON
    }
    
    static func removeHomeSettingAtIndex(index: Int) {
        var oldTitle: String = appInfo!["home"][index]["title"].stringValue
        appInfo!["home"].arrayObject?.removeAtIndex(index)
        appInfo!["subpage"].dictionaryObject!.removeValueForKey(oldTitle)
        println("\(appInfo!)")
    }
    
    static func setHomeSettingAtIndex(index: Int, info homeInfo: JSON) {
        var oldTitle: String = appInfo!["home"][index]["title"].stringValue
        if oldTitle != homeInfo["title"].stringValue {
            appInfo!["subpage"][homeInfo["title"].stringValue] = appInfo!["subpage"][oldTitle]
            appInfo!["subpage"].dictionaryObject!.removeValueForKey(oldTitle)
        }
        appInfo!["home"][index] = homeInfo
    }
    
    static func addHomeSetting(index: Int) {
        println("app info before set: \(appInfo)")
        let length = appInfo!["home"].count
        
        let title = SystemInfomation.cellTemplate["home"][index]["title"].string
        var newHomeSeting: JSON = SystemInfomation.cellTemplate["home"][index]
        var newSubpageSeting: JSON = SystemInfomation.cellTemplate["subpage"][title!]
        
        var index = length
        var newTitle: String = newHomeSeting["title"].stringValue + String(index)
        while (appInfo!["subpage"][newTitle] != nil) {
            index += 1
            newTitle = newHomeSeting["title"].stringValue + String(index)
        }
        newHomeSeting["title"].string = newTitle
        println(appInfo!["home"])
        appInfo!["home"].arrayObject?.append([])
        appInfo!["home"][length] = appInfo!["home"][length - 1]
        appInfo!["home"][length - 1] = newHomeSeting
        println(appInfo!["home"])
        appInfo!["subpage"][newHomeSeting["title"].stringValue] = newSubpageSeting
        println("app info after set: \(appInfo)")
    }
    
    static func getHomeItemInformation(index pageIndex: Int) -> JSON{
        initData()
        return appInfo!["home"][pageIndex]
    }
    
    // for the subpathe info
    static func getSubpageInformation(pageName page: String) -> JSON {
        initData()
        println("in get subpage\(appInfo)")
        return appInfo!["subpage"][page] as JSON
    }
    
    static func setSubpageInformation(pageName page: String, info subpageInformation: JSON) {
        appInfo!["subpage"][page] = subpageInformation
        println("in set subpage \(appInfo)")
        saveItems()
    }
    
    // for the ip info
    static func getIPInfo() -> String {
        initData()
        return appInfo!["ip"].stringValue
    }
    
    static func setIPInfo(#ip: String) {
        appInfo!["ip"].string = ip
        saveItems()
    }
    
    // for set the homepage cell icon
    static func getFunctionIconNumer() -> Int {
        return functionIconSet.count
    }
    
    static func getFunctionIconAtIdex(#index: Int) -> String {
        return functionIconSet[index]
    }
    
    // for the homepage cell template
    static func getCellTemplate() -> JSON {
        return SystemInfomation.cellTemplate
    }
}
