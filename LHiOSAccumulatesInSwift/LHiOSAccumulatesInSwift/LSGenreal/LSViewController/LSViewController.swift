//
//  LSViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LSViewController: UIViewController, LSSectionHeaderViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customLCViewControllerBaseUI()
    }
    
    func customLCViewControllerBaseUI() -> Void {
        let headerView = LSSectionHeaderView.sectionHeaderView(delegate: self, title: self.title, leftText: self.leftItemText(), rightText: self.rightItemText())
        self.view.addSubView(headerView, layoutInfo: LHLayoutInfo.init(top: 0, left: 0, bottom: LHLayoutInfo.layoutNone, right: 0, width: LHLayoutInfo.layoutNone, height: 44))
    }
    
    //MARK: LSSectionHeaderViewDelegate
    func sectionHeaderView(_ sectionHeaderView: LSSectionHeaderView, tappedOnLeftButton leftButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 子类按需继承
    func rightItemText() -> String! {
        return ""
    }
    
    func leftItemText() -> String! {
        return "返回"
    }
    
}
