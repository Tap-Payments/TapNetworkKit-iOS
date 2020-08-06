//
//  StoreiesResponse.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/5/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

//   let storiesResponse = try? newJSONDecoder().decode(StoriesResponse.self, from: jsonData)

import Foundation

// MARK: - StoriesResponse
struct StoriesResponse: Codable {
    let status, copyright, section: String
    let lastUpdated: String
    let numResults: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let section: Section
    let subsection, title, abstract: String
    let url: String
    let uri, byline: String
    let itemType: ItemType
    let updatedDate, createdDate, publishedDate: String
    let materialTypeFacet, kicker: String
    let desFacet, orgFacet, perFacet, geoFacet: [String]
    let multimedia: [Multimedia]
    let shortURL: String

    enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, uri, byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case multimedia
        case shortURL = "short_url"
    }
}

enum ItemType: String, Codable {
    case article = "Article"
    case interactive = "Interactive"
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let url: String
    let format: Format
    let height, width: Int
    let type: TypeEnum
    let subtype: Subtype
    let caption, copyright: String
}

enum Format: String, Codable {
    case mediumThreeByTwo210 = "mediumThreeByTwo210"
    case normal = "Normal"
    case standardThumbnail = "Standard Thumbnail"
    case superJumbo = "superJumbo"
    case thumbLarge = "thumbLarge"
}

enum Subtype: String, Codable {
    case photo = "photo"
}

enum TypeEnum: String, Codable {
    case image = "image"
}

enum Section: String, Codable {
    case arts = "arts"
    case briefing = "briefing"
    case style = "style"
    case us = "us"
    case world = "world"
}
