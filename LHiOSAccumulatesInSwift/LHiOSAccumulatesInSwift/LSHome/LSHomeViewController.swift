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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateControllerControllerContrainerViewWithZoomingState(isZooming: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstLaunch {
            self.firstLaunch = false
            self.updateFlyingIndex(index: 0)
            (self.homeButtons[0] as UIButton).isSelected = true
            self.homeButtonAnimateWithButtonIndex(index: 0, isFlyingAway: true, customCompletion: { () in
                self.maskLabel.text = self.homeButtonTitles[0]
                self.centerCircleAnimateWithIsZooming(isZooming: true, customCompletion: nil)
            })
        }
    }

    func homeButtonAnimateWithButtonIndex(index:Int, isFlyingAway:Bool, customCompletion:(() -> Void)?) {
        let flyingView = self.flyingViews[index] as UIView
        flyingView.isHidden = false
        let stopHomeButtonFlyAwayConstraintActive = !isFlyingAway
        let constraints = (self.flyConstraintArray?[index])! as [NSLayoutConstraint]
        for constraint in constraints {
            constraint.isActive = stopHomeButtonFlyAwayConstraintActive
        }
        UIView.animate(withDuration: 0.6, animations: { 
            flyingView.alpha = isFlyingAway ? 1.0 : 0.4
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished {
                flyingView.isHidden = true
                if let temp = customCompletion {
                    temp()
                }
            }
        }
    }
    
    func centerCircleAnimateWithIsZooming(isZooming:Bool, customCompletion: (() -> Void)?) {
        self.maskLabel.isHidden = false
        self.maskView.isHidden = false
        self.maskLabel.text = self.homeButtonTitles[self.flyingViewIndex]
        let scale = isZooming ? self.view.bounds.size.width * 2 / 50 : 1
        let labelAlpha:CGFloat = isZooming ? 0 : 1
        UIView.animate(withDuration: 0.4, animations: { 
            self.maskView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            self.maskLabel.alpha = labelAlpha
            self.updateControllerControllerContrainerViewWithZoomingState(isZooming: isZooming)
        }) { (finished) in
            if finished {
                self.maskLabel.isHidden = true
                self.maskView.isHidden = !isZooming
                if let temp = customCompletion {
                    temp()
                }
            }
        }
    }
    
    func updateFlyingIndex(index: Int) {
        self.flyingViewIndex = index
        if flyingViewIndex >= 0 {
            for view in self.subViewControllerContainerViews {
                view.isHidden = !(flyingViewIndex == view.tag)
            }
        }
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

    func updateControllerControllerContrainerViewWithZoomingState(isZooming: Bool) {
        let controllerContainerViewScale = isZooming ? 1 : self.self.controllerContainerViewZoomingMin
        let controllerContainerViewAlpha = isZooming ? 1 : 0
        self.controllerContrainerView.transform = CGAffineTransform.identity.scaledBy(x: controllerContainerViewScale, y: controllerContainerViewScale)
        self.controllerContrainerView.alpha = CGFloat(controllerContainerViewAlpha)
    }

    @IBAction func didTapOnHomeButton(_ sender: LSLightBorderButton) {
        let index = sender.tag
        if (index == self.flyingViewIndex || self.isFlying) {
            return
        }
        let currentIndex = self.flyingViewIndex
        sender.isSelected = true
        self.homeButtons[currentIndex].isSelected = false
        self.isFlying = true
        self.centerCircleAnimateWithIsZooming(isZooming: false) { () in
            self.homeButtonAnimateWithButtonIndex(index: currentIndex, isFlyingAway: false, customCompletion: nil)
        }
        self.homeButtonAnimateWithButtonIndex(index: index, isFlyingAway: true) { () in
            self.flyingViewIndex = index;
            self.centerCircleAnimateWithIsZooming(isZooming: true, customCompletion: { () in
                self.isFlying = false
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
