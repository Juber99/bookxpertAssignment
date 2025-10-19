//
//  ArticleRepositoryTests.swift
//  ReaderTests
//
//  Created by juber99 on 19/10/25.
//

import XCTest
import CoreData
@testable import Reader


final class ArticleRepositoryTests: XCTestCase {
    var sut: ArticleRepository!
    var mockAPI: MockAPIService!
    var inMemoryContainer: NSPersistentContainer!

    override func setUpWithError() throws {
        mockAPI = MockAPIService()
        inMemoryContainer = InMemoryCoreData.setupInMemoryContainer()
        sut = ArticleRepository(api: mockAPI, coreContext: inMemoryContainer.viewContext)
    }
    
    func testFetchArticles_Success() {
        // Given
        let dummyArticle = Article(id: "", title: "News 1", author: "", description: "", url: "com.abc", urlToImage: "", publishedAt: nil)
        mockAPI.mockArticles = [dummyArticle]

        let expectation = XCTestExpectation(description: "Fetch articles success")

        // When
        sut.fetchArticles(forceRefresh: true) { result in
            switch result {
            case .success(let articles):
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "News 1")
            case .failure(let error):
                XCTFail("Expected success, got error \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchArticles_OfflineFallback_UsesCache() {
        // Given
        mockAPI.shouldReturnError = true
        // Insert one cached article
        let cdArticle = CDArticle(context: inMemoryContainer.viewContext)
        cdArticle.title = "Cached News"
        cdArticle.url = "offline.com"
        try! inMemoryContainer.viewContext.save()

        let expectation = XCTestExpectation(description: "Uses cached data")

        // When
        sut.fetchArticles(forceRefresh: true) { result in
            switch result {
            case .success(let articles):
                XCTAssertEqual(articles.first?.title, "Cached News")
            case .failure:
                XCTFail("Expected cached fallback")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSaveBookmark_SavesSuccessfully() {
        let article = Article(id: "", title: "Bookmarked", author: "", description: "", url: "com.abc", urlToImage: "", publishedAt: nil)

        sut.saveBookmark(article: article)

        let fetch: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        let results = try! inMemoryContainer.viewContext.fetch(fetch)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Bookmarked")
    }
    
    func testRemoveBookmark_DeletesSuccessfully() {
        // Given
        let context = inMemoryContainer.viewContext
        let cd = CDBookmarkArticle(context: context)
        cd.title = "Bookmarked"
        cd.url = "com.abc"
        try! context.save()

        let article = Article(id: "", title: "Bookmarked", author: "", description: "", url: "com.abc", urlToImage: "", publishedAt: nil)

        // When
        sut.removeBookmark(article)

        // Then
        let fetch: NSFetchRequest<CDBookmarkArticle> = CDBookmarkArticle.fetchRequest()
        let results = try! context.fetch(fetch)
        XCTAssertTrue(results.isEmpty)
    }
    
    func testCheckIfBookmarked_ReturnsTrue() {
        let context = inMemoryContainer.viewContext
        let cd = CDBookmarkArticle(context: context)
        cd.title = "Saved"
        cd.url = "saved.com"
        try! context.save()

        let article = Article(id: "", title: "Saved", author: "", description: "", url: "saved.com", urlToImage: "", publishedAt: nil)

        XCTAssertTrue(sut.checkIfBookmarked(article))
    }
    
    func testFetchBookmarks_ReturnsBookmarkedArticles() {
        let context = inMemoryContainer.viewContext
        let cd1 = CDBookmarkArticle(context: context)
        cd1.title = "Bookmark 1"
        cd1.url = "b1.com"

        let cd2 = CDBookmarkArticle(context: context)
        cd2.title = "Bookmark 2"
        cd2.url = "b2.com"

        try! context.save()

        let bookmarks = sut.fetchBookmarks()
        XCTAssertEqual(bookmarks.count, 2)
    }
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
