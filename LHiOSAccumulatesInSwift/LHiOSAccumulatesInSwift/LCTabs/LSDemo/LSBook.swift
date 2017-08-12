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
    let subTitle: String
    let publisher: String
    let title: String
    let price: String
    let image: String
    let images: Image
    let authors: [String]
    let publishDate: String
    let tags: [Tag]
    let originTitle: String
    let binding: String
    let translator: [String]
    let catalog: String
    let pages: String
    let isbn: String
    let authorIntroduction: String
    let summary: String
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

