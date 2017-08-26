//
//  NSDate+LHUtils.swift
//  LHReadingPlan
//
//  Created by 李辉 on 2017/8/25.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import Foundation

extension Date {
    static func tomorrow() -> Date {
        let tomorrow = Date(timeIntervalSince1970: (NSDate().timeIntervalSince1970 + Date.oneDayInSeconds()))
        let calender = Calendar.current
        let component = calender.dateComponents([.era, .year, .month, .day], from: tomorrow)
        return calender.date(from: component)!
    }
    
    static func oneDayInSeconds() -> TimeInterval {
        return 60 * 60 * 24
    }
    
    func yyMMdd() -> String {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return "\(component.year!)-\(component.month!)-\(component.day!)"
    }
}
