//
//  LSAccumulateManager.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSAccumulateManager: NSObject {
    var accumulates :[LSAccumulate]!
    init(plistFileName fileName: String) {
        self.accumulates = LSUtils.loadAccumulatesFromPlist(plistFileName: fileName)
    }
}
