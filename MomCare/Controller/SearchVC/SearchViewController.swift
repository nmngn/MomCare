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
    var listResult: [User]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    let realm = try! Realm()
    var userSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        searchBar.delegate = self
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: SearchItemTableViewCell.self)
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
                let predicate = NSPredicate(format: "name contains[c]         %@", text)
                let result = realm.objects(User.self).filter(predicate)
                self.listResult = result.toArray()
            }
        }
    }
}
