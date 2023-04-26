//
//  PlaceholderModel.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 19/11/22.
//

import Foundation

// MARK: - PlaceholderElement
struct PlaceholderElement: Codable {
    let userID, id: Int?
    let title, body: String?

    init(placeholderPost : PlaceholderPost) {
        userID = Int(placeholderPost.userId)
        id = placeholderPost.id
        title = placeholderPost.title
        body = placeholderPost.body
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Placeholder = [PlaceholderElement]

struct PlaceholderPost: Codable {
    let id: Int
    let title, body, userId: String
}
