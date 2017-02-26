//
//  LSAccumulate.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSAccumulate: NSObject {
    var title: String!
    
    var viewControllerTitle: String!
    
    var content: String!
    
    var storyboardID: String!
    
    var storyboardName: String!
    
    public init!(dictionary dic: [String : String]!) {
        self.title = dic["title"]
        self.title = dic["title"]
        self.viewControllerTitle = dic["viewControllerTitle"]
        self.content = dic["content"]
        self.storyboardID = dic["storyboardID"]
        self.storyboardName = dic["storyboardName"]
    }
}
