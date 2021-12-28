//
//  SearchViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import UIKit
import RealmSwift

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
    let realm = try! Realm()
    var userSearch = ""
    var contrastColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm kiếm"
        configView()
        setupBackButton()
        changeTheme()
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        setupStatus(isHidden: false, title: "Hãy bắt đầu tìm kiếm")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    
    func setupStatus(isHidden: Bool, title: String) {
        resultView.isHidden = isHidden
        statusLabel.text = title
        statusLabel.textColor = contrastColor
    }
    
    func changeTheme() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 5 {
                self.theme.image = UIImage(named: "time1")
            } else if hour >= 5 && hour < 7 {
                self.theme.image = UIImage(named: "time2")
            } else if hour >= 7 && hour < 9 {
                self.theme.image = UIImage(named: "time3")
            } else if hour >= 9 && hour < 17 {
                self.theme.image = UIImage(named: "time4")
            } else if hour >= 17 && hour < 19 {
                self.theme.image = UIImage(named: "time5")
            } else if hour >= 19 && hour < 23 {
                self.theme.image = UIImage(named: "time2")
            } else {
                self.theme.image = UIImage(named: "time1")
            }
        }
    }
    
    func setupBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(touchBackButton))
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
            cell.setupData(model: listResult[indexPath.row], contrastColor: self.contrastColor)
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
                let predicate = NSPredicate(format: "name contains[c]         %@", text)
                let result = realm.objects(User.self).filter(predicate)
                if result.count == 0 {
                    self.listResult?.removeAll()
                    setupStatus(isHidden: false, title: "Không có kết quả tìm thấy")
                } else {
                    setupStatus(isHidden: true, title: "")
                    self.listResult = result.toArray()
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
