//
//  SearchViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    var listResult: [User]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var userSearch = ""
    let repo = Repositories(api: .share)
    var listUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm kiếm"
        getListUser()
        configView()
        setupBackButton()
        changeTheme(self.theme)
        setupStatus(isHidden: false, title: "Hãy bắt đầu tìm kiếm")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
        setupBackButton()
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomHeightConstraint.constant = keyboardHeight - 18
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomHeightConstraint.constant = 16
        self.view.layoutIfNeeded()
    }
    
    func getListUser() {
        let idAdmin = Session.shared.userProfile.idAdmin
        repo.getAllUser(idAdmin: idAdmin) { [weak self] response in
            switch response {
            case .success(let data):
                if let data = data?.users {
                    self?.listUser = data
                }
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    func setupStatus(isHidden: Bool, title: String) {
        resultView.isHidden = isHidden
        statusLabel.text = title
    }
    
    func setupBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configView() {
        searchBar.delegate = self
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: SearchItemTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemTableViewCell", for: indexPath) as?
                SearchItemTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        if let listResult = self.listResult {
            cell.setupData(model: listResult[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = listResult {
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            vc.currentModel = user[indexPath.row].convertToDetailModel()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                let result = listUser.filter({$0.name.localizedCaseInsensitiveContains(text)})
                if result.count == 0 {
                    self.listResult?.removeAll()
                    setupStatus(isHidden: false, title: "Không có kết quả tìm thấy")
                } else {
                    setupStatus(isHidden: true, title: "")
                    self.listResult = result
                }
            } else {
                self.listResult?.removeAll()
                setupStatus(isHidden: false, title: "Hãy nhập từ khóa để tìm kiếm")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
