//
//  LSSectionHeaderView.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSSectionHeaderView: UIView {
    static func sectionHeaderView(title: String, leftText:String?, rightText:String? ) -> LSSectionHeaderView {
        let view = Bundle.main.loadNibNamed("LSSectionHeaderView", owner: nil, options: nil)!.first
        return view as! LSSectionHeaderView
    }
}
