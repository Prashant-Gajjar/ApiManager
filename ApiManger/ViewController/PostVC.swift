//
//  PostVC.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class PostVC: UIViewController, AlertPresentable {
    //MARK: - Properties
    @IBOutlet private weak var postListTableView: UITableView!
    @IBOutlet private weak var txtUserId: UITextField!
    @IBOutlet private weak var txtTitle: UITextField!
    @IBOutlet private weak var txtBody: UITextField!
    
    private var viewModel: PostViewModel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private Button Actions
    @IBAction private func btnPostClicked() {
        guard let userId = txtUserId.text, !userId.isEmpty,
              let title = txtTitle.text, !title.isEmpty,
              let body = txtBody.text, !body.isEmpty else {
            showAlert(title: "Validation!", message: "Please fill in all fields.")
            return
        }
        
        viewModel.postApiCall(userId: userId, title: title, body: body) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.postListTableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: - Private Methods
    private func setup() {
        let nib = UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil)
        postListTableView.register(nib, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        viewModel = PostViewModel()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(classForCoder)"
    }
}

//MARK: - TableView Methods
extension PostVC: UITableViewDelegate,
                  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ListTableViewCell
        cell.setupCell(obj: viewModel.postViewModel(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension PostVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
