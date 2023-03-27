//
//  ApiManager.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation
import Combine

class ApiManager<T: Codable> {
    //MARK: - Properties
    
    //MARK: - Enum
    enum ApiManagerError: Error {
        case invalidData
        case nilData
    }
    
    var cancellable = Set<AnyCancellable>()
    
    let baseUrl: String
    let endPoint: String
    var httpMethods: String = "GET"
    var parameters: Any? = nil
    var headers: [String: String] = [:]
    
    //MARK: - init
    convenience init(
        baseUrl     : ApiBaseUrl,
        endPoint    : ApiEndPoints,
        httpMethods : HTTPMethods = .get,
        parameters  : Any? = nil,
        headers     : [String: String] = [:]
    ) {
        self.init(
            baseUrl     : baseUrl.rawValue,
            endPoint    : endPoint.rawValue,
            httpMethods : httpMethods.rawValue,
            parameters  : parameters,
            headers     : headers
        )
    }
    
    private init(
        baseUrl     : String,
        endPoint    : String,
        httpMethods : String = "GET",
        parameters  : Any? = nil,
        headers     : [String: String] = [:]
    ) {
        self.baseUrl        = baseUrl
        self.endPoint       = endPoint
        self.httpMethods    = httpMethods
        self.parameters     = parameters
        self.headers        = headers
    }
    
    //MARK: - Public Methods
    public func requestCall(
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseUrl.appending(endPoint)) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethods
        if let parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        headers.forEach({request.setValue($0.value, forHTTPHeaderField: $0.key)})
        
        dataTask(request: request)
            .sink { results in
                switch results {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { data in
                completion(.success(data))
            }
            .store(in: &cancellable)
    }
    
    func dataTask(
        request: URLRequest
    )  -> Future<T, Error> {
        
        return Future { promise in
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { results in
                    switch results {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &self.cancellable)
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
