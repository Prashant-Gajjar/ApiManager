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

    private var viewModel: GetViewModel!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    //MARK: - Methods
    private func setup() {
        let nib = UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)

        viewModel = GetViewModel()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "\(classForCoder)"
    }

    private func fetchData() {
        viewModel.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.listTableView.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //MARK: - Private IBAction
    @IBAction private func btnReloadClicked() {
        fetchData()
    }
}

//MARK: - TableView Methods
extension GetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ListTableViewCell
        if let model = viewModel.getItem(at: indexPath.row) {
            cell.setupCell(obj: model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
