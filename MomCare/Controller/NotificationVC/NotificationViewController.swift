//
//  NotificationViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 29/12/2021.
//

import UIKit
import RealmSwift

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var titleBell: UILabel!
    
    var notiModel = [NotificationModel]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.notification
        self.setupNavigationButton()
        self.configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.notiModel.isEmpty {
            self.setupStatus(isHidden: false, title: Constant.Text.noNotify)
        } else {
            self.setupStatus(isHidden: true, title: "")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupNavigationButton()
        self.tableView.reloadData()
    }
    
    func configView() {
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: NotificationTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        }
    }
    
    func setupStatus(isHidden: Bool, title: String) {
        self.bellView.isHidden = isHidden
        self.titleBell.text = title
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        self.navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notiModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.className, for: indexPath) as?
                NotificationTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupData(model: self.notiModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = notiModel[indexPath.row].id
        guard let infoUser = realm.objects(User.self).first(where: {$0.idUser == id}) else { return }
        let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
        vc.currentModel = infoUser.convertToDetailModel()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
