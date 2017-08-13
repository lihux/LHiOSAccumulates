//
//  LSGeneralDefines.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 2017/8/13.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import Foundation

#if (arch(i386) || arch(x86_64)) && os(iOS)
    let DEVICE_IS_SIMULATOR = true
#else
    let DEVICE_IS_SIMULATOR = false
#endif
