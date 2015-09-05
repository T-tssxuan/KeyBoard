//
//  SystemInfomation.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/9/5.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class SystemInfomation: NSObject {
    static let cellTemplate: JSON = [
        "ip": "127.0.0.1",
        "home":
            [
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
                    "mouse": 1
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

}
