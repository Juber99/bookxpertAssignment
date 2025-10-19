//
//  CDArticle+Mapping.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import Foundation
import CoreData
extension CDArticle {
    func update(from article: Article) {
        self.id = article.id ?? article.url
        self.title = article.title
        self.author = article.author
        self.descText = article.description
        self.url = article.url
        self.imageURL = article.urlToImage
        self.publishedAt = article.publishedAt
    }

    func toDomain() -> Article {
        return Article(
            id: self.id,
            title: self.title ?? "",
            author: self.author,
            description: self.descText,
            url: self.url,
            urlToImage: self.imageURL,
            publishedAt: self.publishedAt
        )
    }
    
}

extension CDBookmarkArticle {
    func toBookmarkArticle() -> BookmarkArticle {
        return BookmarkArticle(id:"", title: self.title ?? "", author: self.author, description: self.description, url: self.url, urlToImage: self.imageUrl)
    }
}
