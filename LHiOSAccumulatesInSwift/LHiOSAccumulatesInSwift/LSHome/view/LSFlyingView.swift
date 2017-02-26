//
//  LSFlyingView.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 2017/2/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LSFlyingView: UIView {
    var lsMaskView: UIView?
    var lsMaskLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        for view in self.subviews {
            if view.isKind(of: UILabel.classForCoder()) {
                self.lsMaskLabel = view as? UILabel
                self.lsMaskLabel?.backgroundColor = UIColor.clear
            } else {
                self.lsMaskView = view
            }
        }
    }
    //
    //    - (void)setAlpha:(CGFloat)alpha
    //    {
    //    if (self.maskView && self.maskLabel) {
    //    self.maskLabel.alpha = alpha == 1.0 ? 1.0 : 0.4;
    //    self.maskView.alpha = alpha == 1.0 ? 0.2 : 0;
    //    } else {
    //    [super setAlpha:alpha];
    //    }
    //    }
}
