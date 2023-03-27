//
//  HTTPMethods+Helper.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 27/03/23.
//

import Foundation

struct HTTPMethods: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    static let connect = HTTPMethods(rawValue: "CONNECT")
    /// `DELETE` method.
    static let delete = HTTPMethods(rawValue: "DELETE")
    /// `GET` method.
    static let get = HTTPMethods(rawValue: "GET")
    /// `HEAD` method.
    static let head = HTTPMethods(rawValue: "HEAD")
    /// `OPTIONS` method.
    static let options = HTTPMethods(rawValue: "OPTIONS")
    /// `PATCH` method.
    static let patch = HTTPMethods(rawValue: "PATCH")
    /// `POST` method.
    static let post = HTTPMethods(rawValue: "POST")
    /// `PUT` method.
    static let put = HTTPMethods(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = HTTPMethods(rawValue: "QUERY")
    /// `TRACE` method.
    static let trace = HTTPMethods(rawValue: "TRACE")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
