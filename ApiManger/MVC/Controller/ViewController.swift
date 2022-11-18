//
//  ViewController.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet private weak var listTableView: UITableView!
    
    private let urlStr = "https://pixabay.com/api/?key=\(constant.apiKey)&q=yellow+flowers&image_type=photo&pretty=true"
    
    private var photosModel: PhotosModel?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "ListTableViewCell")
        
        apiCall()
    }

    private func apiCall() {
        ApiManager.shared.requestCall(
            url         : URL(string: urlStr),
            methods     : .GET,
            expecting   : PhotosModel.self
        ){ [weak self] result in
            switch result {
            case .success(let photosModel):
                self?.photosModel = photosModel
                DispatchQueue.main.async {
                    self?.listTableView.reloadData()
                    self?.listTableView.layoutIfNeeded()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - TableView Methods
extension ViewController: UITableViewDelegate,
                          UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosModel?.hits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.hit = photosModel?.hits?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
