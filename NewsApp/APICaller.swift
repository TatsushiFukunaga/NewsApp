//
//  APICaller.swift
//  NewsApp
//
//  Created by 福永竜之 on 2021/05/15.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private let baseUrl = "https://newsapi.org/v2/top-headlines?language="
    private let apiKey = "&pageSize=50&apiKey=61f1fb5d0dcd4f86bbcd74f562a29b20"
    var language: String?
    
    struct Contants {
        //static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?language=en&pageSize=50&apiKey=61f1fb5d0dcd4f86bbcd74f562a29b20")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&language=en&apiKey=61f1fb5d0dcd4f86bbcd74f562a29b20&q="
    }
    
    private init() {}
    
//    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void) {
//        guard let url = Contants.topHeadLinesURL else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//            }
//            else if let data = data {
//                do {
//                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
//                    completion(.success(result.articles))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//        }
//        task.resume()
//    }
    
    public func getTopStoriesInOtherLanguage(with language: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        let urlString = baseUrl + language + apiKey
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Contants.searchUrlString + query
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
