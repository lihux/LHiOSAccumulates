//
//  UIView+LHAutoLayout.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/7/11.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

struct LHLayoutInfo {
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, width: CGFloat, height: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
        self.width = width
        self.height = height
    }
    var top: CGFloat
    var left: CGFloat
    var bottom: CGFloat
    var right: CGFloat
    var width: CGFloat
    var height: CGFloat
    static let layoutNone = CGFloat.greatestFiniteMagnitude
}

extension UIView {
    func addSubViewUsingDefaultLayoutConstraints(_ view: UIView) -> Void {
        self.addSubview(view)
        self.addDefaultConstraintsForSubView(view)
    }
    
    func addSubView(_ view: UIView, layoutInfo:LHLayoutInfo) -> Void {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.layoutView(view, constant: layoutInfo.top, attributeName: .top)
        self.layoutView(view, constant: layoutInfo.left, attributeName: .left)
        self.layoutView(view, constant: layoutInfo.bottom, attributeName: .bottom)
        self.layoutView(view, constant: layoutInfo.right, attributeName: .right)
        self.layoutView(view, constant: layoutInfo.width, attributeName: .width)
        self.layoutView(view, constant: layoutInfo.height, attributeName: .height)
    }
    
    func insertSubviewUsingDefaultLayoutConstraints(_ view: UIView, at:Int) -> Void {
        self.insertSubview(view, at: at)
        self.addSubViewUsingDefaultLayoutConstraints(view)
    }
    
    func insertSubviewUsingDefaultLayoutConstraints(_ view: UIView, aboveSubview: UIView) -> Void {
        self.insertSubview(view, aboveSubview: aboveSubview)
        self.addSubViewUsingDefaultLayoutConstraints(view)
    }
    
    func insertSubviewUsingDefaultLayoutConstraints(_ view: UIView, belowSubview: UIView) -> Void {
        self.insertSubview(view, belowSubview: belowSubview)
        self.addSubViewUsingDefaultLayoutConstraints(view)
    }
    
    func lh_widthConstraint() -> NSLayoutConstraint? {
        var result: NSLayoutConstraint?
        self.constraints.forEach { (constraint: NSLayoutConstraint) in
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .width {
                result = constraint
            }
        }
        return result
    }
    func lh_heightConstraint() -> NSLayoutConstraint? {
        var result: NSLayoutConstraint?
        self.constraints.forEach { (constraint: NSLayoutConstraint) in
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == .width {
                result = constraint
            }
        }
        return result
    }
    
    private func layoutView(_ view:UIView, constant: CGFloat, attributeName: NSLayoutAttribute) -> Void {
        if constant != CGFloat.greatestFiniteMagnitude {
            var vfl:String?
            let metrics = ["constant": constant]
            switch attributeName {
            case .top:
                vfl = "V:|-constant-[view]"
            case .left:
                vfl = "H:|-constant-[view]"
            case .bottom:
                vfl = "V:[view]-constant-|"
            case .right:
                vfl = "H:[view]-constant-|"
            case .width:
                vfl = "H:[view(constant)]"
            case .height:
                vfl = "V:[view(constant)]"
            default:
                break
            }
            if let temp = vfl {
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: temp, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["view": view]))
            }
        }
    }
    
    private func addDefaultConstraintsForSubView(_ view: UIView) -> Void {
        view.translatesAutoresizingMaskIntoConstraints = false
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllBottom, metrics: nil, views: ["view": view])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllBottom, metrics: nil, views: ["view": view])
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraints)
    }
}
