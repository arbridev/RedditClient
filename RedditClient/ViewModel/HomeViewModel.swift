//
//  HomeViewModel.swift
//  RedditClient
//
//  Created by Armando Brito on 7/1/23.
//

import UIKit
import Combine

class HomeViewModel {

    private let networkService = NetworkService()
    private let persistenceService = PersistenceService()

    var updateUI: (() -> Void)?
    private(set) var posts: [Post] = [Post]()
    private var cancellable: AnyCancellable?
    private var cancellableSearch: AnyCancellable?

    var searchPublisher: NotificationCenter.Publisher? {
        didSet {
            setupSearch()
        }
    }

    var isPermissionFlowComplete: Bool {
        persistenceService.isPermissionFlowComplete
    }

    func loadPosts() {
        cancellable = networkService.fetchAll().sink { result in
            print("Result", result)
        } receiveValue: { [weak self] posts in
            let filtered = posts.filter({
                $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
            })
            self?.posts = filtered
            self?.updateUI?()
        }
    }

    private func setupSearch() {
        cancellableSearch = searchPublisher?.compactMap { notification in
            (notification.object as! UITextField).text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        }
        .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        .flatMap({ query in
            self.networkService.fetchSearch(withQuery: query)
                .catch { _ in
                    return Empty()
                }
                    .map({ $0 })
        }).sink { result in
            print("Result", result)
        } receiveValue: { [weak self] posts in
            let filtered = posts.filter({
                $0.data.linkFlairText == "Shitposting" && $0.data.postHint == "image"
            })
            self?.posts = filtered
            self?.updateUI?()
        }
    }

}
