//
//  Post.swift
//  RedditClient
//
//  Created by Armando Brito on 9/1/23.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let kind: String
    let data: PostData
}

// MARK: - PostData
struct PostData: Codable {
    let title: String
    let linkFlairText: String?
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
