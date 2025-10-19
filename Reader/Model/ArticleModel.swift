//
//  ArticleModel.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import Foundation
struct ArticleResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable, Equatable {
    let id: String? // optional unique id if API provides
    let title: String
    let author: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?

    enum CodingKeys: String, CodingKey {
        case title, author, description, url, urlToImage, publishedAt, id
    }
}

struct BookmarkArticle {
    let id: String? // optional unique id if API provides
    let title: String
    let author: String?
    let description: String?
    let url: String?
    let urlToImage: String?
}
