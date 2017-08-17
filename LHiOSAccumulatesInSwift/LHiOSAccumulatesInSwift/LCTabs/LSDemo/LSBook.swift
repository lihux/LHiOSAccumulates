//
//  LSBook.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/11.
//  Copyright © 2017年 Lihux. All rights reserved.
//

/*
 Codable 使用注意：
 1. 如果添加了CodingKeys，那么就必须要将所有的key值都列出来，感觉好费劲；
 2. 映射的时候要保证所有的子结构体都要有遵从Codable协议；
 3. 可以嵌套无缝定义完美贴合json返回值的子、孙结构体，但条件是子孙结构体都要遵循规则1和2
 */

import Foundation

struct LSBook: Codable {
    let rating: Rating
    var subTitle: String?
    var publisher: String?
    let title: String
    let price: String
    let image: String
    let images: Image
    let authors: [String]
    let publishDate: String
    var tags: [Tag]?
    var originTitle: String?
    var binding: String?
    let translator: [String]
    var catalog: String?
    let pages: String
    let isbn: String
    var authorIntroduction: String?
    var summary: String?
    var series: Series?
}

// MARK: CodingKey
extension LSBook {
    enum CodingKeys: String, CodingKey {
        case rating
        case subTitle = "subtitle"
        case publisher
        case title
        case price
        case image
        case images
        case authors = "author"
        case publishDate = "pubdate"
        case tags
        case originTitle = "origin_title"
        case binding
        case translator
        case catalog
        case pages
        case isbn = "isbn13"
        case authorIntroduction = "author_intro"
        case summary
        case series
    }
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
    
    struct Tag: Codable {
        let count: Int
        let name: String
        let title: String
    }
    
    struct Series: Codable {
        let seriesID: String
        let title: String
        enum CodingKeys: String, CodingKey {
            case seriesID = "id"
            case title
        }
    }
}

