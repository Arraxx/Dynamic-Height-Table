//
//  WikiModel.swift
//  dynamicHeightTable
//
//  Created by Arrax on 14/01/24.
//

import Foundation

struct WikiModel : Decodable {
    let batchComplete : String
    let query : Query
    enum CodingKeys : String, CodingKey{
        case batchComplete = "batchcomplete"
        case query
    }
}

struct Query : Decodable{
    let pages : [String: Pages]
}

struct Pages : Decodable{
    let pageId: Int
    let ns: Int
    let title: String
    let index: Int
    let thumbnail: Thumbnail?
    let pageImage: String?
    let extract: String

    enum CodingKeys: String, CodingKey {
        case pageId = "pageid"
        case ns
        case title
        case index
        case thumbnail
        case pageImage = "pageimage"
        case extract
    }
}

struct Thumbnail : Decodable{
    let source : String
    let width : Int
    let height : Int
}
