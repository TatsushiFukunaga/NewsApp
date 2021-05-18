//
//  APICaller.swift
//  NewsApp
//
//  Created by 福永竜之 on 2021/05/15.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private let headlines = "https://newsapi.org/v2/top-headlines?language="
    private let everything = "https://newsapi.org/v2/everything?sortBy=popularity&language="
    private let apiKey = "&pageSize=50&apiKey=61f1fb5d0dcd4f86bbcd74f562a29b20"
    
    private init() {}
    
    public func getTopStories(with language: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        let urlString = headlines + language + apiKey
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
    
    public func search(with language: String, with query: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = everything + language + apiKey + "&q=" + query
        
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
