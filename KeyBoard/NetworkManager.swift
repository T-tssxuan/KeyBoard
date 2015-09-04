//
//  NetworkManager.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/8/22.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class NetworkManager: NSObject, NSStreamDelegate {
    
    var writeStream: Unmanaged<CFWriteStream>?
    var outputStream: NSOutputStream?
    var inputStrean: NSInputStream?
    var timer: NSTimer?
    var timerThread: NSThread?
    
    var tryCount: Int = 0
    
    var netWorkStatus: Bool = false {
        didSet {
            if netWorkStatus {
                timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("heartBeat"), userInfo: nil, repeats: true)
                NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
                timer?.fire()
            } else {
                println("timer stoped")
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    static var sharedInstance = NetworkManager()
    
    func send(#msg: String) {
        println("NetworkManager send \(msg)")
        let unsafePointerOfN = (msg as NSString).UTF8String
        let len: Int = Int(strlen(unsafePointerOfN))
        println("\(len)")
        if netWorkStatus {
            outputStream?.write(UnsafeMutablePointer(unsafePointerOfN), maxLength: len)
        }
    }
    
    func connect() {
        // increase the connect try time
        
        if netWorkStatus {
            return
        }
        
        tryCount += 1
        
        NetworkManager.sharedInstance.disconnect()
        var arr: [String] = split(InfoManager.getIPInfo(), maxSplit: Int.max, allowEmptySlices: true) { $0 == ","}
        let host = arr[0]
//        let port = UInt32(arr[1].toInt()!)
        let port: UInt32 = 3001
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host as CFString, port, nil, &writeStream)
        outputStream = writeStream!.takeRetainedValue()
        outputStream!.delegate = self
        outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.outputStream!.open()
        })
//        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "hearBeat:", userInfo: nil, repeats: true)
    }
    
    static var a = 0
    
    func heartBeat() {
        NetworkManager.a += 1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.send(msg: "heartbeat")
        })
        println("\(NetworkManager.a)")
    }
    
    func disconnect() {
        self.outputStream?.close()
    }
    
    func stream(aStream: NSStream, handleEvent aStreamEvent: NSStreamEvent) {
        let note = NSNotificationCenter.defaultCenter()
        switch aStreamEvent {
        case NSStreamEvent.OpenCompleted:
            println("network open")
            netWorkStatus = true
            // reset the connect try count
            tryCount = 0
            note.postNotificationName("network_info", object: self, userInfo: ["status": "connected"])
        case NSStreamEvent.HasBytesAvailable:
            println("network has bytes available")
        case NSStreamEvent.HasSpaceAvailable:
            println("network has space availiable")
        case NSStreamEvent.ErrorOccurred:
            println("network has error occured")
            if tryCount < 3 {
                connect()
            } else {
                disconnect()
            }
            note.postNotificationName("network_info", object: self, userInfo: ["status": "error", "try_count": String(tryCount)])
            netWorkStatus = false
        case NSStreamEvent.EndEncountered:
            println("network end encounterd")
            note.postNotificationName("network_info", object: self, userInfo: ["status": "disconnected"])
            netWorkStatus = false
        default:
            println("network others")
            netWorkStatus = false
        }
    }
}
