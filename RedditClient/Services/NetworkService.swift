//
//  NetworkService.swift
//  RedditClient
//
//  Created by Armando Brito on 6/1/23.
//

import Foundation
import Combine

protocol RedditService {

    func fetchAll() -> AnyPublisher<[Post], Error>
    func fetchSearch(withQuery query: String) -> AnyPublisher<[Post], Error>

}

class NetworkService: RedditService {

    func fetchAll() -> AnyPublisher<[Post], Error> {
        return URLSession.shared.dataTaskPublisher(for: .all)
            .map({ $0.data })
            .decode(type: PostsResponse.self, decoder: JSONDecoder())
            .map({ $0.data.children })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchSearch(withQuery query: String) -> AnyPublisher<[Post], Error> {
        return URLSession.shared.dataTaskPublisher(for: .search(withQuery: query))
            .map({ $0.data })
            .decode(type: PostsResponse.self, decoder: JSONDecoder())
            .map({ $0.data.children })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

fileprivate extension URL {

    static var all: URL {
        makeForEndpoint("r/chile/new/.json?limit=100")
    }

    static func search(withQuery query: String) -> URL {
        makeForEndpoint("r/chile/search.json?q=\(query)&limit=100")
    }

    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://www.reddit.com/\(endpoint)")!
    }

}
