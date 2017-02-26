//
//  LSHomeViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 2017/2/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LSHomeViewController: LSBasicViewController {

    @IBOutlet var homeButtons: [LSLightBorderButton]!
    @IBOutlet var homeButtonACVerticalSpaceConstraints:[NSLayoutConstraint]!
    @IBOutlet var homeButtonCRHorizontalSpaceConstraints:[NSLayoutConstraint]!
    @IBOutlet var maskView:UIView!
    @IBOutlet var maskLabel:UILabel!
    @IBOutlet var controllerContrainerView:UIView!
    @IBOutlet var flyView1SizeConstraints:[NSLayoutConstraint]!
    @IBOutlet var flyView2SizeConstraints:[NSLayoutConstraint]!
    @IBOutlet var flyView3SizeConstraints:[NSLayoutConstraint]!
    @IBOutlet var flyView4SizeConstraints:[NSLayoutConstraint]!
    @IBOutlet var flyingViews:[UIView]!
    @IBOutlet var subViewControllerContainerViews:[UIView]!

    var flyingViewIndex = -1
    var firstLaunch = true
    let homeButtonTitles = ["好玩", "好看", "你猜", "设置"]
    var isFlying = false
    var controllerContainerViewZoomingMin:CGFloat {
        get {
            let size = self.controllerContrainerView.frame.size
            let length = min(size.width, size.height)
            return 50 / length
        }
    }

    var flyConstraintArray:[[NSLayoutConstraint]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adjustLayoutConstraints()
        self.prepareDatas()
    }

    func adjustLayoutConstraints() {
        let buttonWidth = (self.homeButtons[0] as UIButton).bounds.size.width;
        let borderGap:CGFloat = 22.0
        let buttonCount = self.homeButtons.count
        let widthConstant = (UIScreen.main.bounds.size.width - borderGap - (buttonWidth * CGFloat(buttonCount))) / CGFloat(buttonCount - 1)
        for constraint in self.homeButtonACVerticalSpaceConstraints {
            constraint.constant = widthConstant
        }
        for constraint in self.homeButtonCRHorizontalSpaceConstraints {
            constraint.constant = widthConstant;
        }
    }

    func prepareDatas() {
        self.flyConstraintArray = [self.flyView1SizeConstraints, self.flyView2SizeConstraints, self.flyView3SizeConstraints, self.flyView4SizeConstraints]
        self.flyingViews = self.flyingViews.sorted(by: { (view1, view2) -> Bool in
            view1.tag < view2.tag
        })
    }
    @IBAction func didTapOnHomeButton(_ sender: LSLightBorderButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
