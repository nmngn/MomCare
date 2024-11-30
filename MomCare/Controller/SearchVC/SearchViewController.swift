//
//  SearchViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import UIKit
import RealmSwift

class SearchViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    var listResult: [User]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    let realm = try! Realm()
    var userSearch = ""
    var listUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.search
        self.getListUser()
        self.configView()
        self.setupBackButton()
        self.setupStatus(isHidden: false, title: Constant.Text.letSearch)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupBackButton()
        self.tableView.reloadData()
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
        self.bottomHeightConstraint.constant = 16
        self.view.layoutIfNeeded()
    }
    
    func getListUser() {
        self.listUser = realm.objects(User.self).toArray()
    }
    
    func setupStatus(isHidden: Bool, title: String) {
        self.resultView.isHidden = isHidden
        self.statusLabel.text = title
    }
    
    func setupBackButton() {
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configView() {
        self.searchBar.delegate = self
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: SearchItemTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        }
    }
    
    @objc func search(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                let result = listUser.filter({$0.name.localizedCaseInsensitiveContains(text)})
                if result.count == 0 {
                    self.listResult?.removeAll()
                    setupStatus(isHidden: false, title: Constant.Text.noResult)
                } else {
                    setupStatus(isHidden: true, title: "")
                    self.listResult = result
                }
            } else {
                self.listResult?.removeAll()
                setupStatus(isHidden: false, title: Constant.Text.letSearch)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemTableViewCell.className, for: indexPath) as?
                SearchItemTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        if let listResult = self.listResult {
            cell.setupData(model: listResult[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = listResult {
            let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
            vc.currentModel = user[indexPath.row].convertToDetailModel()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(_:)), object: searchBar)
        perform(#selector(self.search(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        perform(#selector(self.search(_:)), with: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
