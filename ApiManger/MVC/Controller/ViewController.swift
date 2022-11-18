//
//  ViewController.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    let urlStr = "https://pixabay.com/api/?key=\(constant.apiKey)&q=yellow+flowers&image_type=photo&pretty=true"
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private Methods
    private func apiCall() {
        ApiManager.shared.requestCall(
            url         : URL(string: urlStr),
            methods     : .GET,
            expecting   : PhotosModel.self
        ){ result in
            switch result {
            case .success(let photosModel):
                print(photosModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
