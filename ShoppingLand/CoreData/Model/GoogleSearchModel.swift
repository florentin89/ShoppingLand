//
//  GoogleSearchModel.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 25/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import Foundation

// Structure for Google JSON Response for Images Search
struct GoogleSearchModel: Codable {
    let kind: String
    let url: URLGoogle
    let queries: Queries
    let context: Context
    let searchInformation: SearchInformation
    let spelling: Spelling
    let items: [Item]
}

struct Context: Codable {
    let title: String
}

struct Item: Codable {
    let kind: Kind
    let title, htmlTitle, link, displayLink: String
    let snippet, htmlSnippet: String
    let mime: MIME
    let image: Image
}

struct Image: Codable {
    let contextLink: String
    let height, width, byteSize: Int
    let thumbnailLink: String
    let thumbnailHeight, thumbnailWidth: Int
}

enum Kind: String, Codable {
    case customsearchResult = "customsearch#result"
}

enum MIME: String, Codable {
    case image = "image/"
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
}

struct Queries: Codable {
    let request, nextPage: [NextPage]
}

struct NextPage: Codable {
    let title, totalResults, searchTerms: String
    let count, startIndex: Int
    let inputEncoding, outputEncoding, safe, cx: String
    let searchType, imgSize, imgType: String
}

struct SearchInformation: Codable {
    let searchTime: Double
    let formattedSearchTime, totalResults, formattedTotalResults: String
}

struct Spelling: Codable {
    let correctedQuery, htmlCorrectedQuery: String
}

struct URLGoogle: Codable {
    let type, template: String
}
