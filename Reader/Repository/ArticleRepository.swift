//
//  ArticleRepository.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import Foundation
import CoreData

protocol ArticleRepositoryProtocol {
    func fetchArticles(forceRefresh: Bool, completion: @escaping (Result<[Article], Error>) -> Void)
    func searchLocalArticles(query: String) -> [Article]
    func toggleBookmark(article: Article)
    func getBookmarkedArticles() -> [Article]
    func saveBookmark(article: Article)
    func fetchBookmarks() -> [BookmarkArticle]
    func removeBookmark(_ article: Article)
    func checkIfBookmarked(_ article: Article) -> Bool
    
}

final class ArticleRepository: ArticleRepositoryProtocol {
    private let api: APIServiceProtocol
    private let core: NSManagedObjectContext

    init(api: APIServiceProtocol = APIService(), coreContext: NSManagedObjectContext = PersistantStorage.shared.context) {
        self.api = api
        self.core = coreContext
    }

    func fetchArticles(forceRefresh: Bool = false, completion: @escaping (Result<[Article], Error>) -> Void) {
        // Try network
        api.fetchTopHeadlines { [weak self] res in
            switch res {
            case .success(let articles):
                // Save to Core Data
                self?.saveArticlesToCoreData(articles: articles)
                completion(.success(articles))
            case .failure:
                // On failure, return cached
                let cached = self?.fetchCachedArticles() ?? []
                if cached.isEmpty {
                    completion(.failure(NSError(domain: "Offline", code: -1, userInfo: [NSLocalizedDescriptionKey: "No cached content."])))
                } else {
                    completion(.success(cached))
                }
            }
        }
    }

    private func saveArticlesToCoreData(articles: [Article]) {
        let context = PersistantStorage.shared.context  // use background context

           context.perform {
               // Clean old data first (optional)
               let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDArticle.fetchRequest()
               let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
               try! context.execute(deleteRequest)

               // Save new data
               for article in articles {
                   let cdArticle = CDArticle(context: context)
                   cdArticle.title = article.title
                   cdArticle.author = article.author
                   cdArticle.imageURL = article.urlToImage
                   cdArticle.url = article.url
               }

               do {
                   try context.save()
               } catch {
                   print("❌ CoreData save error:", error)
               }
           }
    }

    private func fetchCachedArticles() -> [Article] {
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        do {
            let results = try core.fetch(req)
            return results.map { $0.toDomain() }
        } catch {
            print("Fetch cached error: \(error)")
            return []
        }
    }

    func searchLocalArticles(query: String) -> [Article] {
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        if !query.isEmpty {
            req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        do {
            let res = try core.fetch(req)
            return res.map { $0.toDomain() }
        } catch {
            print("Search error: \(error)")
            return []
        }
    }

    func toggleBookmark(article: Article) {
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "url == %@", article.url ?? "")
        do {
            let items = try core.fetch(req)
            if let cd = items.first {
                cd.isBookmarked.toggle()
            } else {
                // create new and mark bookmarked
                let cd = CDArticle(context: core)
                cd.update(from: article)
                cd.isBookmarked = true
            }
            try core.save()
        } catch {
            print("Toggle bookmark error: \(error)")
        }
    }

    func getBookmarkedArticles() -> [Article] {
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "isBookmarked == YES")
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        do {
            let res = try core.fetch(req)
            return res.map { $0.toDomain() }
        } catch {
            print("Get bookmarks error: \(error)")
            return []
        }
    }
    
    func saveBookmark(article: Article) {
       
        let context = self.core
        
        // Check if already bookmarked
        let fetchRequest: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url!)
        
        do {
            let existing = try context.fetch(fetchRequest)
            if existing.isEmpty {
                let bookmark = CDBookmarkArticle(context: context)
                bookmark.title = article.title
                bookmark.author = article.author
                bookmark.url = article.url
                bookmark.imageUrl = article.urlToImage
                try context.save()
                print("✅ Bookmark saved!")
            } else {
                print("ℹ️ Already bookmarked.")
            }
        } catch {
            print("❌ Error saving bookmark:", error)
        }
    }
    
    func fetchBookmarks() -> [BookmarkArticle] {
     
        let context = self.core

        let fetchRequest: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        do {
            var result = [BookmarkArticle]()
            let  bookmarkedArticles = try context.fetch(fetchRequest)
            for art in bookmarkedArticles {
                result.append(BookmarkArticle(id: "", title: art.title ?? "", author: art.author, description: art.description, url: art.url, urlToImage: art.imageUrl))
            }
            print("✅ Loaded \(bookmarkedArticles.count) bookmarks")
            return result
           
        } catch {
            print("❌ Error fetching bookmarks:", error)
            return []
           
        }
    }
    
    func removeBookmark(_ article: Article) {
        
        let context = self.core

        let fetchRequest: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url!)

        do {
            let results = try context.fetch(fetchRequest)
            for obj in results {
                context.delete(obj)
            }
            try context.save()
            print("🗑️ Removed bookmark")
        } catch {
            print("❌ Remove error:", error)
        }
    }
    
    func checkIfBookmarked(_ article: Article) -> Bool {
      
        let context = self.core

        let fetchRequest: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url!)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("❌ Check bookmark error:", error)
            return false
        }
    }
    
    
}
