//
//  ApiManager.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation

extension URLSession {
    enum ApiManagerError: Error {
        case invalidUrl
        case invalidData
    }
    
    
    func request<T: Codable>(
        url         : URL?,
        expecting   : T.Type,
        completion  : @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(ApiManagerError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
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
        task.resume() 
    }
}
