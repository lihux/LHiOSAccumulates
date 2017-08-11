//
//  LSSectionHeaderView.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

protocol LSSectionHeaderViewDelegate: class {
    func sectionHeaderView(_ sectionHeaderView:LSSectionHeaderView, tappedOnLeftButton leftButton:UIButton) -> Void;
}

class LSSectionHeaderView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    weak var delegate: LSSectionHeaderViewDelegate?
    static func sectionHeaderView(delegate:LSSectionHeaderViewDelegate, title: String?, leftText:String?, rightText:String? ) -> LSSectionHeaderView {
        let view = Bundle.main.loadNibNamed("LSSectionHeaderView", owner: nil, options: nil)!.first as! LSSectionHeaderView
        view.delegate = delegate
        if let temp = title {
            view.titleLabel.text = temp;
        }
        if let temp = leftText {
            view.leftButton.titleLabel?.text = temp
        }
        if let temp = rightText {
            view.rightButton.titleLabel?.text = temp
        }
        return view
    }
}
