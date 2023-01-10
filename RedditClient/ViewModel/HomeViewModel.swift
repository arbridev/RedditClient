//
//  HomeViewModel.swift
//  RedditClient
//
//  Created by Armando Brito on 7/1/23.
//

import Foundation
import Combine

class HomeViewModel {

    enum Request {
        case all
        case search
    }

    private let networkService = NetworkService()
    private let persistenceService = PersistenceService()

    var updateUI: (() -> Void)?
    private(set) var posts: [Post] = [Post]()
    private var cancellable: AnyCancellable?
    private var cancellableSearch: AnyCancellable?
    private var lastRequest: Request?
    private var lastQuery: String?
    private var afterPage: String?

    var searchPublisher: AnyPublisher<String, Never>? {
        didSet {
            setupSearch()
        }
    }

    var isPermissionFlowComplete: Bool {
        persistenceService.isPermissionFlowComplete
    }

    func loadPosts() {
        cacheRequestState(type: .all)
        cancellable = networkService.fetchAll(after: afterPage)
            .sink { result in
                print("Result", result)
            } receiveValue: { [weak self] posts, after in
                let filtered = posts.filter({
                    $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
                })
                self?.posts = filtered
                self?.afterPage = after
                self?.updateUI?()
            }
    }

    func paginate() {
        switch lastRequest {
            case .all:
                cancellable = networkService.fetchAll(after: afterPage)
                    .sink { result in
                        print("Result", result)
                    } receiveValue: { [weak self] posts, after in
                        let filtered = posts.filter({
                            $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
                        })
                        self?.posts = filtered
                        self?.afterPage = after
                        self?.updateUI?()
                    }
            case .search:
                guard let lastQuery else {
                    return
                }
                cancellableSearch = fetchSearch(withQuery: lastQuery, after: self.afterPage)
                    .sink { result in
                        print("Result", result)
                    } receiveValue: { [weak self] posts, after in
                        let filtered = posts.filter({
                            $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
                        })
                        self?.posts = filtered
                        self?.afterPage = after
                        self?.updateUI?()
                    }
            default:
                break
        }
    }

    private func setupSearch() {
        cancellableSearch = searchPublisher?
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .flatMap({ query in
                self.fetchSearch(withQuery: query, after: self.afterPage)
                    .catch { _ in
                        Just<([Post], String?)>(([], nil))
                    }
                    .map { $0 }
            })
            .sink(receiveValue: { [weak self] posts, after in
                let filtered = posts.filter({
                    $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
                })
                self?.posts = filtered
                self?.afterPage = after
                self?.updateUI?()
            })
    }

    private func cacheRequestState(type: Request) {
        afterPage = lastRequest != type ? nil : afterPage
        lastRequest = type
    }

    private func fetchSearch(
        withQuery query: String,
        after page: String?
    ) -> AnyPublisher<([Post], String?), Error> {
        if query.isEmpty {
            lastQuery = nil
            cacheRequestState(type: .all)
            return networkService.fetchAll(after: afterPage)
        }
        lastQuery = query
        cacheRequestState(type: .search)
        return networkService.fetchSearch(withQuery: query, after: self.afterPage)
    }

}
