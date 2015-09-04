//
//  NetworkViewController.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/9/4.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit
import AVFoundation

class NetworkViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var ipView: UIView!
    var ipLable: UILabel!
    var ipTextField: UITextField!
    var QRCodeView: UIView!
    var nav: UINavigationBar!
    var barItems: UINavigationItem!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initQRCodeScan()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLayout() {
        
        view.backgroundColor = ColorItem.getColor(index: 0)
        
        nav = UINavigationBar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 60
            )
        )
        
        barItems = UINavigationItem()
        barItems.title = "Network Setting"
//        let barOk: UIBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let barOK = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done:")
        nav.pushNavigationItem(barItems, animated: true)
        barItems.setRightBarButtonItem(barOK, animated: true)
        
        view.addSubview(nav)
        
        ipView = UIView(
            frame: CGRect(
                x: (UIScreen.mainScreen().bounds.width - 300) / 2,
                y: 100,
                width: 300,
                height: 35
            )
        )
        ipView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(ipView)
        
        ipLable = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
        ipLable.textAlignment = NSTextAlignment.Center
        ipLable.text = "Host IP:"
        ipLable.font = UIFont(name: "", size: 30)
        ipView.addSubview(ipLable)
        
        ipTextField = UITextField(
            frame: CGRect(
                x: 80,
                y: 0,
                width: 220,
                height: 35
            )
        )
        ipTextField.textAlignment = NSTextAlignment.Left
        ipTextField.text = InfoManager.getIPInfo()
        ipTextField.font = UIFont(name: "", size: 30)
        ipView.addSubview(ipTextField)
        
        QRCodeView = UIView(
            frame: CGRect(
                x: (UIScreen.mainScreen().bounds.width - 300) / 2,
                y: 200,
                width: 300,
                height: 300
            )
        )
        QRCodeView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(QRCodeView)
        
        qrCodeFrameView = UIView()
        qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView.layer.borderWidth = 2
        QRCodeView.addSubview(qrCodeFrameView)
        QRCodeView.bringSubviewToFront(qrCodeFrameView)
    }
    
    func done(sender: AnyObject) {
        InfoManager.setIPInfo(ip: ipTextField.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initQRCodeScan() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
//            println("\(error?.localizedDescription)")
            barItems.title = "Camera unavailablef"
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession.addInput(input as! AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = QRCodeView.frame
        QRCodeView.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRectZero
            ipTextField.text = "No QR code is detected~"
            return
        }
        
        let metaObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject =  videoPreviewLayer.transformedMetadataObjectForMetadataObject(metaObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView.frame = barCodeObject.bounds
            if metaObj.stringValue != nil {
                ipTextField.text = metaObj.stringValue
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
