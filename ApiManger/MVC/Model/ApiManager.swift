//
//  ApiManager.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation

class ApiManager {
    //MARK: - Properties
    static let shared = ApiManager()
    
    //MARK: - Enum
    enum ApiManagerError: Error {
        case invalidUrl, invalidData
    }
    
    enum HTTPSMethods {
        case get, patch, delete, put, post(parameters: Dictionary<String,Any>?)
        
        var rawValue: String {
            switch self {
            case .get:
                return "GET"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
            case .post:
                return "POST"
            }
        }
    }
    
    //MARK: - init
    private init() { }
    
    //MARK: - Public Methods
    public func requestCall<T: Codable>(
        url         : URL?,
        methods     : HTTPSMethods = .get,
        parameters  : Dictionary<String, Any>? = nil,
        expecting   : T.Type,
        completion  : @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(ApiManagerError.invalidUrl))
            return
        }
        
        let request = createRequest(url, methods)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.checkResponse(response)
            self.fetch(expecting: expecting, data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    //MARK: - Private Methods
    private func createRequest(_ url: URL, _ methods: ApiManager.HTTPSMethods) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = methods.rawValue
        
        switch methods {
        case .get, .patch, .delete, .put:
            break
        case .post(parameters: let parameters):
            request.httpBody = parameters?.percentEscaped().data(using: .utf8)
        }
        return request
    }
    
    private func checkResponse(_ response: URLResponse?) {
        if let response = response as? HTTPURLResponse {
            guard (200...299) ~= response.statusCode else {
                print("Status Code : ", response.statusCode)
                print("Response : ", response)
                return
            }
        }
    }
    
    /// This is the method that can be used by any URLSession third party
    /// - Parameters:
    ///   - expecting: Pass Expected Model Type
    ///   - data: data from api response
    ///   - error: error from api response
    ///   - completion: completion with `success` or `failure`
    private func fetch<T: Codable>(
        expecting   : T.Type,
        data        : Data?,
        error       : Error?,
        completion  : @escaping ((Result<T, Error>) -> Void)
    ) {
        guard let data = data else {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(ApiManagerError.invalidData))
            }
            return
        }
        
        do {
            let result = try JSONDecoder().decode(expecting, from: data)
            completion(.success(result))
        }
        catch {
            completion(.failure(error))
        }
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters:
                    .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters:
                    .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined (separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn:
                        "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
