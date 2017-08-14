//
//  LSBookScanViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 2017/8/12.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit
import AVFoundation

class LSBookScanViewController: LSViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEVICE_IS_SIMULATOR {
            //TODO:直接返回，甩出去一个常量值即可
        } else {
            self.startScan()
        }
    }
    
    func startScan() -> Void {
        let device = AVCaptureDevice.default(for: .video)
        do {
            let input = try AVCaptureDeviceInput.init(device: device!)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session = AVCaptureSession()
            session!.sessionPreset = .high
            session!.addInput(input)
            session!.addOutput(output)
            output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
            let layer = AVCaptureVideoPreviewLayer(session: session!)
            layer.videoGravity = .resizeAspectFill
            layer.frame = CGRect(x: 10, y: 100, width: 300, height: 200)
            self.view.layer.addSublayer(layer)
            session!.startRunning()
        } catch let error as NSError {
            print("\(error.localizedDescription):\n\(error.userInfo)")
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            session!.stopRunning()
            let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print("扫描成功，条形码信息为：\(metaDataObject.stringValue!)")
        }
    }
    
}
