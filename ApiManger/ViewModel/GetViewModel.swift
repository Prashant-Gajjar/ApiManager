//
//  GetViewModel.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 13/08/23.
//

import Foundation

// ViewModel for GetVC
class GetViewModel {
    private var placeholderModel: [PlaceholderElement] = []

    var numberOfItems: Int {
        return placeholderModel.count
    }

    func getItem(at index: Int) -> PlaceholderElement? {
        guard index >= 0, index < placeholderModel.count else {
            return nil
        }
        return placeholderModel[index]
    }

    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        let apiManager = APIWrapper<[PlaceholderElement]>(
            baseApi: .jsonplaceholder
        )

        apiManager.call() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                self.placeholderModel = models
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
