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
        outputStream?.write(UnsafeMutablePointer(unsafePointerOfN), maxLength: len)
    }
    
    func connect(#host: String, remotePort port: UInt32) {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host as CFString, port, nil, &writeStream)
        outputStream = writeStream!.takeRetainedValue()
        outputStream!.delegate = self
        outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream?.open()
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
        
    }
    
    func stream(aStream: NSStream, handleEvent aStreamEvent: NSStreamEvent) {
        switch aStreamEvent {
        case NSStreamEvent.OpenCompleted:
            println("open")
            netWorkStatus = true
        case NSStreamEvent.HasBytesAvailable:
            println("has bytes available")
        case NSStreamEvent.HasSpaceAvailable:
            println("has space availiable")
        case NSStreamEvent.ErrorOccurred:
            println("has error occured")
            netWorkStatus = false
        case NSStreamEvent.EndEncountered:
            println("end encounterd")
            netWorkStatus = false
        default:
            println("others")
            netWorkStatus = false
        }
    }
}
