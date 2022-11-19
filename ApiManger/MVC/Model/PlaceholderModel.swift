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

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Placeholder = [PlaceholderElement]
