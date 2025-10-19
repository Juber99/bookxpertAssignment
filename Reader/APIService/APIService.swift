//
//  APIService.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import Foundation


enum NetworkError: Error {
    case invalidURL, requestFailed(Error), badResponse, decodingError(Error)
}

protocol APIServiceProtocol {
    func fetchTopHeadlines(completion: @escaping (Result<[Article], NetworkError>) -> Void)
}

final class APIService: APIServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let apiKey: String? // set if using NewsAPI

    init(session: URLSession = .shared, apiKey: String? = nil) {
        self.session = session
        self.apiKey = Constants.apiKey
        self.decoder = JSONDecoder()
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let date = df.date(from: str) { return date }
            // fallback
            let fallback = ISO8601DateFormatter().date(from: str)
            if let d = fallback { return d }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date")
        }
    }

    func fetchTopHeadlines(completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        // Example using NewsAPI.org - replace endpoint & key if you use another service
        guard var components = URLComponents(string: Constants.apiURL) else {
            completion(.failure(.invalidURL)); return
        }
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            // add more params if needed
        ]
        guard let url = components.url else {
            completion(.failure(.invalidURL)); return
        }

        var request = URLRequest(url: url)
        if let key = apiKey {
            request.addValue(key, forHTTPHeaderField: "X-Api-Key")
        }

        let task = session.dataTask(with: request) { data, resp, err in
            if let err = err { completion(.failure(.requestFailed(err))); return }
            guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode, let data = data else {
                completion(.failure(.badResponse)); return
            }
            do {
                let root = try self.decoder.decode(ArticleResponse.self, from: data)
                completion(.success(root.articles))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
