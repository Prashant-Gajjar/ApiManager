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
    
    let apiKey = "31407132-980cbd0d0672136e9cefde8f4"
    
    enum JsonplaceholderApis {
        case jsonplaceholderGet
        case jsonplaceholderPost(parameters: Dictionary<String, Any>?)
        
        var api: String {
            return "https://jsonplaceholder.typicode.com/posts/"
        }
        
        var method: ApiManager.HTTPSMethods {
            switch self{
            case .jsonplaceholderGet:
                return .get
            case .jsonplaceholderPost(let parameters):
                return .post(parameters: parameters)
            }
        }
    }
}
