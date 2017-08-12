//
//  LSBook.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/11.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import Foundation

struct LSBook: Codable {
    let publisher: String
    let title: String
    let price: String
    let image: String
    struct Image: Codable {
        let small: String
        let large: String
        let medium: String
    }
    let images: Image
}
