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
        case invalidUrl
        case invalidData
    }
    
    enum HTTPSMethods: String {
        case GET, POST, PATCH, DELETE, PUT
    }
    
    //MARK: - init
    private init() {
        
    }
    
    //MARK: - Public Methods
    public func requestCall<T: Codable>(
        url         : URL?,
        methods     : HTTPSMethods = .GET,
        expecting   : T.Type,
        completion  : @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(ApiManagerError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methods.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.checkResponse(response)
            self.fetch(expecting: expecting, data: data, error: error, completion: completion)
        }
        task.resume()
    }
    
    //MARK: - Private Methods
    
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
        
    private func checkResponse(_ response: URLResponse?) {
        if let response = response as? HTTPURLResponse {
            guard (200...299) ~= response.statusCode else {
                print("Status Code : ", response.statusCode)
                print("Response : ", response)
                return
            }
        }
    }
    
}
