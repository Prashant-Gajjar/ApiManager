//
//  PhotosModel.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation

// MARK: - PhotosModel
struct PhotosModel: Codable {
    let total, totalHits: Int?
    let hits: [Hit]?
}

// MARK: PhotosModel convenience initializers and mutators

extension PhotosModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotosModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        total: Int?? = nil,
        totalHits: Int?? = nil,
        hits: [Hit]?? = nil
    ) -> PhotosModel {
        return PhotosModel(
            total: total ?? self.total,
            totalHits: totalHits ?? self.totalHits,
            hits: hits ?? self.hits
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Hit
struct Hit: Codable {
    let id: Int?
    let pageURL: String?
    let type: TypeEnum?
    let tags: String?
    let previewURL: String?
    let previewWidth, previewHeight: Int?
    let webformatURL: String?
    let webformatWidth, webformatHeight: Int?
    let largeImageURL: String?
    let imageWidth, imageHeight, imageSize, views: Int?
    let downloads, collections, likes, comments: Int?
    let userID: Int?
    let user: String?
    let userImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
}

// MARK: Hit convenience initializers and mutators

extension Hit {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Hit.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        pageURL: String?? = nil,
        type: TypeEnum?? = nil,
        tags: String?? = nil,
        previewURL: String?? = nil,
        previewWidth: Int?? = nil,
        previewHeight: Int?? = nil,
        webformatURL: String?? = nil,
        webformatWidth: Int?? = nil,
        webformatHeight: Int?? = nil,
        largeImageURL: String?? = nil,
        imageWidth: Int?? = nil,
        imageHeight: Int?? = nil,
        imageSize: Int?? = nil,
        views: Int?? = nil,
        downloads: Int?? = nil,
        collections: Int?? = nil,
        likes: Int?? = nil,
        comments: Int?? = nil,
        userID: Int?? = nil,
        user: String?? = nil,
        userImageURL: String?? = nil
    ) -> Hit {
        return Hit(
            id: id ?? self.id,
            pageURL: pageURL ?? self.pageURL,
            type: type ?? self.type,
            tags: tags ?? self.tags,
            previewURL: previewURL ?? self.previewURL,
            previewWidth: previewWidth ?? self.previewWidth,
            previewHeight: previewHeight ?? self.previewHeight,
            webformatURL: webformatURL ?? self.webformatURL,
            webformatWidth: webformatWidth ?? self.webformatWidth,
            webformatHeight: webformatHeight ?? self.webformatHeight,
            largeImageURL: largeImageURL ?? self.largeImageURL,
            imageWidth: imageWidth ?? self.imageWidth,
            imageHeight: imageHeight ?? self.imageHeight,
            imageSize: imageSize ?? self.imageSize,
            views: views ?? self.views,
            downloads: downloads ?? self.downloads,
            collections: collections ?? self.collections,
            likes: likes ?? self.likes,
            comments: comments ?? self.comments,
            userID: userID ?? self.userID,
            user: user ?? self.user,
            userImageURL: userImageURL ?? self.userImageURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum TypeEnum: String, Codable {
    case photo = "photo"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
