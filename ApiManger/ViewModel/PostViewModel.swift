//
//  PostViewModel.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 13/08/23.
//

import Foundation

// ViewModel for PostVC
class PostViewModel {
    private var placeholderModel: [PlaceholderElement] = []

    func postApiCall(userId: String, title: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameter = ["userId": userId, "title": title, "body": body]
        let apiManager = APIWrapper<PlaceholderPost>(
            baseApi: .jsonplaceholder,
            method: .post,
            parameter: .formEncoded(parameter)
        )

        apiManager.call() { result in
            switch result {
            case .success(let obj):
                self.placeholderModel = [PlaceholderElement(placeholderPost: obj)]
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return placeholderModel.count
    }
    
    func postViewModel(at index: Int) -> PlaceholderElement {
        return placeholderModel[index]
    }
}
