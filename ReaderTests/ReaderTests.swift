//
//  ReaderTests.swift
//  ReaderTests
//
//  Created by juber99 on 18/10/25.
//

import XCTest
import CoreData
@testable import Reader


// MARK: - Mock API Service
final class MockAPIService: APIServiceProtocol {
    
    var shouldReturnError = false
    var mockArticles: [Article] = []

    func fetchTopHeadlines(completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidURL))
        } else {
            completion(.success(mockArticles))
        }
    }
}

// MARK: - In-Memory Core Data Stack
final class InMemoryCoreData {
    static func setupInMemoryContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Reader")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            XCTAssertNil(error)
        }
        return container
    }
}


final class ReaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
