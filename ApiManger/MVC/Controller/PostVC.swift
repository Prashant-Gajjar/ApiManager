//
//  PostVC.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class PostVC: UIViewController {
    //MARK: - Properties
    @IBOutlet private weak var listTableView : UITableView!
    @IBOutlet private weak var txtUserId     : UITextField!
    @IBOutlet private weak var txtTitle      : UITextField!
    @IBOutlet private weak var txtBody       : UITextField!
    
    private var placeholderModel: Placeholder?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private Button Actions
    @IBAction private func btnPostClicked() {
        
        let userIdValidation = check(txtField: txtUserId)
        let titleValidation  = check(txtField: txtTitle)
        let bodyValidation   = check(txtField: txtBody)
        
        if !userIdValidation.isValid {
            self.validationAlert(for: "User Id")
            return
        }
        
        if !titleValidation.isValid {
            self.validationAlert(for: "Title")
            return
        }
        
        if !bodyValidation.isValid {
            self.validationAlert(for: "Body")
            return
        }
        
        postApiCall(parameter: ["userId" : userIdValidation.txt,
                                "title"  : titleValidation.txt,
                                "body"   : bodyValidation.txt])
    }
    
    //MARK: - Private Methods
    private func setup() {
        
        txtTitle.text = "Prashant"
        txtUserId.text = "001"
        txtBody.text = "iOS Developer"
        
        [txtBody, txtTitle, txtUserId].forEach({$0?.delegate = self})
        
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "ListTableViewCell")
    }

    private func postApiCall(parameter: Dictionary<String,Any>) {
        
        let api = Constant.JsonplaceholderApis.jsonplaceholderPost(parameters: parameter)
        
        ApiManager.shared.requestCall(
            url         : URL(string: api.api),
            methods     : api.method,
            expecting   : PlaceholderPost.self
        ){ [weak self] result in
            switch result {
            case .success(let obj):
                self?.placeholderModel = [PlaceholderElement(placeholderPost: obj)]
                DispatchQueue.main.async {
                    self?.listTableView.reloadData()
                    self?.listTableView.layoutIfNeeded()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //validations
    private func check(txtField: UITextField) -> (isValid: Bool, txt: String) {
        if let text = txtField.text {
            if text.count != 0 {
                return (true, text)
            }
        }
        return (false, "")
    }
    
    private func validationAlert(for txtFieldName: String) {
        let alert = UIAlertController(title: "Validation!", message: "Please enter \(txtFieldName)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true)
        return
    }
}

//MARK: - TableView Methods
extension PostVC: UITableViewDelegate,
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
        return 50
    }
}


extension PostVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
