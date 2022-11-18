//
//  ViewController.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        let urlStr = "https://pixabay.com/api/?key=\(constant.apiKey)&q=yellow+flowers&image_type=photo&pretty=true "
        
        URLSession.shared.request(
            url         : URL(string: urlStr),
            expecting   : PhotosModel.self
        ) { result in
            switch result {
            case .success(let photosModel):
                print(photosModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}

