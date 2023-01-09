//
//  PostsResponse.swift
//  RedditClient
//
//  Created by Armando Brito on 7/1/23.
//

import Foundation

// MARK: - PostsResponse
struct PostsResponse: Codable {
    let kind: String
    let data: PostsResponseData
}

// MARK: - PostsResponseData
struct PostsResponseData: Codable {
    let after: String?
    let children: [Post]

    enum CodingKeys: String, CodingKey {
        case after
        case children
    }
}
