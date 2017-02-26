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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapOnHomeButton(_ sender: LSLightBorderButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
