//
//  AppUtil.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import Foundation

let constant = Constant.shared

class Constant {
    static let shared = Constant()
    
    private init() {
        
    }
        
    enum JsonPlaceholderApis {
        case jsonPlaceholderGet
        case jsonPlaceholderPost(parameters: Dictionary<String, Any>?)
        
        var api: String {
            return "https://jsonplaceholder.typicode.com/posts/"
        }
        
        var method: ApiManager.HTTPSMethods {
            switch self{
            case .jsonPlaceholderGet:
                return .get
            case .jsonPlaceholderPost(let parameters):
                return .post(parameters: parameters)
            }
        }
    }
}
