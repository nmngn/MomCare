//
//  UserBornViewController.swift
//  MomCare
//
//  Created by NamNT1 on 30/11/24.
//

import UIKit
import RxSwift

class UserBornViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let viewModel: UserBornViewModel
    let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.configView()
        self.bindViewModel()
    }
    
    init(viewModel: UserBornViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        viewModel.listUser.asObservable().subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposedBag)
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: UserBornTableViewCell.self)
        }
        searchBar.delegate = self
    }
    
    func setupNavigation() {
        self.title = "Sản phụ đã sinh"
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        self.navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func search(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                let result = viewModel.defaultListUser.filter({$0.name.localizedCaseInsensitiveContains(text)})
                if result.count == 0 {
                    self.viewModel.listUser.accept([])
                } else {
                    self.viewModel.listUser.accept(result)
                }
            } else {
                self.viewModel.listUser.accept(viewModel.defaultListUser)
            }
        }
    }
}

extension UserBornViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listUser.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserBornTableViewCell.className) as? UserBornTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.listUser.value[indexPath.row]
        cell.setupData(model: data)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.listUser.value[indexPath.row]
        let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
        vc.currentModel.id = model.idUser
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserBornViewController: UISearchBarDelegate {
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
