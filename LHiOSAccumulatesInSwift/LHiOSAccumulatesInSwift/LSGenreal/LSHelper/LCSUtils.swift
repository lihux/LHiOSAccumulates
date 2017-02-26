//
//  LCSUtils.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 2017/2/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LCSUtils: NSObject {
    class func loadAccumulatesFromPlist(plistFileName fileName: String!) -> [LSAccumulate]! {
        
        let plistPath = Bundle.main.path(forResource: fileName, ofType: "plist")
        let tempArray = NSArray.init(contentsOfFile: plistPath!)
        var accumulates = [LSAccumulate]()
        tempArray?.enumerateObjects({ (object, index, stop) in
            if let dic = object as? [String :String] {
                accumulates.append(LSAccumulate(dictionary: dic))
            }
        })
        return accumulates
    }

    class func viewControllerForAccumulate(accumulate: LSAccumulate!) -> UIViewController? {
        if accumulate.storyboardID.lengthOfBytes(using: .utf8) > 0 {
            return UIStoryboard.init(name: accumulate.storyboardName, bundle: nil).instantiateViewController(withIdentifier: accumulate.storyboardID)
        }
        return nil
    }
}

