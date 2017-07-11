//
//  UIColor+Utilities.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import Foundation

import UIKit

extension UIColor
{
    class func colorWith(_ red:Int, green:Int, blue:Int, alpha:CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    class func colorWith(_ red:Int, green:Int, blue:Int) -> UIColor {
        return self.colorWith(red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func colorWithHex(_ value:Int) -> UIColor {
        let r: Int = (value & 0xFF0000) >> 16
        let g: Int = (value & 0x00FF00) >> 8
        let b = value & 0x0000FF
        return self.colorWith(r, green: g, blue: b, alpha: 1.0)
    }
    
    func blend(_ color:UIColor, alpha:CGFloat) -> UIColor {
        let alphaTarget = min(1.0, max(0.0, alpha))
        let belta = 1.0 - alphaTarget
        var r1:CGFloat = 0, g1:CGFloat = 0, b1:CGFloat = 0, a1:CGFloat = 0, r2:CGFloat = 0, g2:CGFloat = 0, b2:CGFloat = 0, a2:CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let red = r1 * belta + r2 * alphaTarget
        let green = g1 * belta + g2 * alphaTarget
        let blue = b1 * belta + b2 * alphaTarget
        let alpha2 = a1 * belta + a2 * alphaTarget
        return UIColor(red: red, green: green, blue: blue, alpha: alpha2)
    }
}
