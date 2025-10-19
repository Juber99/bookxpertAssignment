//
//  ArticleViewModel.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import Foundation


final class ArticleListViewModel {
    private let repo: ArticleRepositoryProtocol

    private(set) var articles: [Article] = [] {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?

    init(repo: ArticleRepositoryProtocol = ArticleRepository()) {
        self.repo = repo
    }

    func loadArticles(forceRefresh: Bool = false) {
        repo.fetchArticles(forceRefresh: forceRefresh) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success(let arts):
                    self?.articles = arts
                case .failure(let err):
                    print("Load error: \(err.localizedDescription)")
                    self?.articles = [] // or keep previous cached
                }
            }
        }
    }

    func search(query: String) {
        // search local
        articles = repo.searchLocalArticles(query: query)
    }

    func toggleBookmark(article: Article) {
        repo.toggleBookmark(article: article)
    }

    func bookmarkedArticles() -> [Article] {
        repo.getBookmarkedArticles()
    }
    
    func convertDatetoString(article: Article) -> String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        return formatter3.string(from: article.publishedAt ?? Date())
    }
    
    func saveBookmarkArticle(_ article: Article) {
        repo.saveBookmark(article: article)
    }
    
    func deleteBookmarkArticle(_ article: Article) {
        repo.removeBookmark(article)
    }
    
    func fetchBookMarkArticle() -> [BookmarkArticle] {
        return repo.fetchBookmarks()
    }
    
    func checkBookmarkArticle(_ article: Article) -> Bool {
        return repo.checkIfBookmarked(article)
    }
}
