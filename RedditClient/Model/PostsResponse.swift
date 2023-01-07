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
    let after: String
    let children: [Post]

    enum CodingKeys: String, CodingKey {
        case after
        case children
    }
}

// MARK: - Post
struct Post: Codable {
    let kind: String
    let data: PostData
}

// MARK: - PostData
struct PostData: Codable {
    let title: String
    let linkFlairText: String
    let score: Int
    let postHint: String?
    let numComments: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case title
        case linkFlairText = "link_flair_text"
        case score
        case postHint = "post_hint"
        case numComments = "num_comments"
        case url
    }
}
