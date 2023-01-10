//
//  NetworkService.swift
//  RedditClient
//
//  Created by Armando Brito on 6/1/23.
//

import Foundation
import Combine

protocol RedditService {

    func fetchAll(after page: String?) -> AnyPublisher<([Post], String?), Error>
    func fetchSearch(
        withQuery query: String,
        after page: String?
    ) -> AnyPublisher<([Post], String?), Error>

}

class NetworkService: RedditService {

    func fetchAll(after page: String? = nil) -> AnyPublisher<([Post], String?), Error> {
        let url: URL = page == nil ? URL.all : URL.all(after: page!)
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: PostsResponse.self, decoder: JSONDecoder())
            .map({ ($0.data.children, $0.data.after) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchSearch(
        withQuery query: String,
        after page: String? = nil
    ) -> AnyPublisher<([Post], String?), Error> {
        let url: URL = page == nil ?
        URL.search(withQuery: query) :
        URL.search(withQuery: query, after: page!)
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: PostsResponse.self, decoder: JSONDecoder())
            .map({ ($0.data.children, $0.data.after) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

fileprivate extension URL {

    static var all: URL {
        makeForEndpoint("r/chile/new/.json?limit=100")
    }

    static func all(after page: String) -> URL {
        makeForEndpoint("r/chile/new/.json?limit=100&after=\(page)")
    }

    static func search(withQuery query: String) -> URL {
        makeForEndpoint("r/chile/search.json?q=\(query)&limit=100")
    }

    static func search(withQuery query: String, after page: String) -> URL {
        makeForEndpoint("r/chile/search.json?q=\(query)&limit=100&after=\(page)")
    }

    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://www.reddit.com/\(endpoint)")!
    }

}
