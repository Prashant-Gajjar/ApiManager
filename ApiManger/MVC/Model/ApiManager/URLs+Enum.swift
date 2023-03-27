//
//  URLs+Enum.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 28/03/23.
//

import Foundation

struct ApiBaseUrl: RawRepresentable, Equatable, Hashable {
    static let jsonplaceholder = ApiBaseUrl(rawValue: "https://jsonplaceholder.typicode.com")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

struct ApiEndPoints: RawRepresentable, Equatable, Hashable {
    static let posts = ApiEndPoints(rawValue: "/posts/")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
