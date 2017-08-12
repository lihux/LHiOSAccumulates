//
//  LSBook.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/11.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import Foundation

struct LSBook: Codable {
    let rating: Rating
    let subtitle: String
    let publisher: String
    let title: String
    let price: String
    let image: String
    let images: Image
}

// MARK: Inner Struct Defines
extension LSBook {
    struct Rating: Codable {
        let max: Int
        let numRaters: Int
        let average: String
    }
    
    struct Image: Codable {
        let small: String
        let large: String
        let medium: String
    }
}

extension LSBook {
    
}
