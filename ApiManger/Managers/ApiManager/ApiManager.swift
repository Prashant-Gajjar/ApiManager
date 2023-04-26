//
//  ApiManager.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation
import Combine

//MARK: - ManagerCompletionResultsBlock
typealias ManagerCompletionResultsBlock<T: Decodable> = (Result<T, Error>) -> Void

//MARK: - APIWrapper
class APIWrapper<T: Codable> {
    let baseApi     : String
    var endPoint    : String = ""
    var queryItems  = [String: String]()
    var method      = "GET"
    var parameter   : Data? = nil
    var header      : [String : String]? = nil
    
    enum ParameterType {
        case jsonEncoded(Any)
        case formEncoded([String: Any])
        case none
    }
    
    deinit {
        print("APIWrapper 💥 deinit 💥 ")
    }

    init(baseApi    : String,
         endPoint   : String = "",
         queryItems : [String: String] = [:],
         method     : String = "GET",
         parameter  : Data? = nil,
         header     : [String : String]? = nil
    ) {
        self.baseApi    = baseApi
        self.endPoint   = endPoint
        self.queryItems = queryItems
        self.method     = method
        self.parameter  = parameter
        self.header     = header
    }

    convenience init(baseApi    : APIBaseUrls,
                     endPoint   : APIEndPoint = .none,
                     queryItems : [String: String] = [:],
                     method     : HTTPMethods = .get,
                     parameter  : ParameterType = .none,
                     header     : [String: String]? = nil
    ) {
        var param: Data? = nil
        switch parameter {
        case .jsonEncoded(let obj):
            param = try? JSONSerialization.data(withJSONObject: obj)
        case .formEncoded(let obj):
            param = obj.percentEscaped().data(using: .utf8)
        case .none: break
        }
        
        self.init(baseApi       : baseApi.rawValue,
                  endPoint      : endPoint.rawValue,
                  queryItems    : queryItems,
                  method        : method.rawValue,
                  parameter     : param,
                  header        : header)
    }
}

// MARK: - APIWrapper via URLSession Data task
extension APIWrapper {
    ///
    ///```
    ///let apiWrapper = APIWrapper<ModelResponse>(
    ///    baseApi     : .baseApi,
    ///    endPoint    : .endPoint,
    ///    method      : .get,
    ///    header      : headers
    ///)
    ///
    ///apiWrapper.call { [weak self] result in
    ///    guard let self else { return }
    ///    switch result {
    ///    case .success(let data):
    ///        break
    ///    case .failure:
    ///        break
    ///    }
    ///}
    ///
    /// ```
    ///
    /// - Created by
    ///
    /// Prashant G
    func call(completion: @escaping ManagerCompletionResultsBlock<T>) {
        do {
            let request = try generateURLRequest()
            URLSession.shared.dataTask(with: request) { data, _, error in

                guard let data else {
                    DispatchQueue.main.async {
                        completion(.failure(error ?? URLError(.badServerResponse)))
                        print("\(#function) ", String(describing: error))
                    }
                    return
                }

                do {
                    let dataModel = try self.decode(data)
                    DispatchQueue.main.async {
                        completion(.success(dataModel))
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                        completion(.failure(decodingError))
                        print("\(#function) ", decodingError)
                    }
                }
            }.resume()
        } catch let error {
            DispatchQueue.main.async {
                completion(.failure(error))
                print("\(#function) ", error)
            }
        }
    }
}

// MARK: - APIWrapper via Publisher
extension APIWrapper {

    func callWithURLSessionPublisher() -> AnyPublisher<T, Error> {
        do {
            let request = try generateURLRequest()
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail(error: error)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - APIWrapper via AsyncAwait
extension APIWrapper {
    ///This is how to use callWithURLSessionAsyncAwait()
    ///
    ///```
    /////This is how to use callWithURLSessionAsyncAwait()
    ///Task {
    ///    let result = await apiWrapper.callWithURLSessionAsyncAwait()
    ///
    ///    switch result {
    ///    case .success(let data):
    ///        break
    ///    case .failure:
    ///        break
    ///    }
    ///}
    /// ```
    ///
    /// - Created by
    ///
    /// Prashant G
    func callWithURLSessionAsyncAwait() async -> Result<T, Error> {
        do {
            let request = try generateURLRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            let dataModel = try decode(data)
            return .success(dataModel)

        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Helper
extension APIWrapper {
    fileprivate func decode(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            throw error
        }
    }

    fileprivate func generateURLRequest() throws -> URLRequest {
        guard var url = URL(string: self.baseApi.appending(endPoint)) else {
            throw URLError(.badURL)
        }
        
        queryItems.forEach({url.appendQueryItem(name: $0.key, value: $0.value)})
        
        var request = URLRequest(url: url, timeoutInterval: 100)
        header?.forEach({request.addValue($0.value, forHTTPHeaderField: $0.key)})
        
        request.httpMethod = method
        
        if let parameter {
            request.httpBody = parameter
        }
        
        return request
    }
}

// MARK: - struct HTTPMethods
struct HTTPMethods: RawRepresentable, Equatable, Hashable {
    static let connect = HTTPMethods(rawValue: "CONNECT")
    static let delete = HTTPMethods(rawValue: "DELETE")
    static let get = HTTPMethods(rawValue: "GET")
    static let head = HTTPMethods(rawValue: "HEAD")
    static let options = HTTPMethods(rawValue: "OPTIONS")
    static let patch = HTTPMethods(rawValue: "PATCH")
    static let post = HTTPMethods(rawValue: "POST")
    static let put = HTTPMethods(rawValue: "PUT")
    static let trace = HTTPMethods(rawValue: "TRACE")
    
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - URLs struct
struct APIBaseUrls: RawRepresentable, Equatable, Hashable {
    static let webhook = APIBaseUrls(rawValue: "https://webhook.site/45604e1d-ea17-4efb-a33f-4e53f027a2a1")
    static let jsonplaceholder = APIBaseUrls(rawValue: "https://jsonplaceholder.typicode.com/posts/")

    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

struct APIEndPoint: RawRepresentable, Equatable, Hashable {
    static let posts = APIEndPoint(rawValue: "/posts/")

    static let none = APIEndPoint(rawValue: "")
    
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK:- helper
extension URL {
    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        // Returns the url from new url components
        if let components = urlComponents.url {
            self = components
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

