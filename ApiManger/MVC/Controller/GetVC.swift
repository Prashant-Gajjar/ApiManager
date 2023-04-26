//
//  GetVC.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class GetVC: UIViewController, AlertPresentable {
    //MARK: - Properties
    @IBOutlet private weak var listTableView: UITableView!
        
    private var placeholderModel: Placeholder?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private IBAction
    @IBAction private func btnReloadClicked() {
        getApiCall()
    }
    
    //MARK: - Private Methods
    private func setup() {
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "ListTableViewCell")
        getApiCall()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(classForCoder)"
    }
    
    private func getApiCall() {
                
        let apiManager = APIWrapper<Placeholder>(
            baseApi     : .jsonplaceholder
        )

        apiManager.call() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let obj):
                self.placeholderModel = obj
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                    self.listTableView.layoutIfNeeded()
                }
            case .failure(let error):
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

//MARK: - TableView Methods
extension GetVC: UITableViewDelegate,
                 UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeholderModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.setupCell(obj: placeholderModel?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
