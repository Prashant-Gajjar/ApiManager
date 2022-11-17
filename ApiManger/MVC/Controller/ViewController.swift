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
        let urlStrl = "https://pixabay.com/api/?key=\(constant.apiKey)&q=yellow+flowers&image_type=photo&pretty=true"
        
        guard let url = URL(string: urlStrl) else {
            print("wrong url")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("nil data")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print(json)
            }
        }
        task.resume()
        
    }

}

