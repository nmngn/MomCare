//
//  SettingViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 17/06/2022.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var model = [SettingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.setting
        self.changeTheme(self.theme)
        self.setupNavigationButton()
        self.configView()
        self.setupData()
    }
    
    func configView() {
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: SettingTimeTableViewCell.self)
            $0.registerNibCellFor(type: SettingSwitchTableViewCell.self)
        }
    }
    
    func setupData() {
        var time = SettingModel(type: .time)
        time.title = Constant.Text.timeSetting
        
        var isEditting = SettingModel(type: .isEditting)
        isEditting.title = Constant.Text.allowEditImage
        isEditting.isEditting = AppManager.shared.getIsEdittingValue()
        
        self.model.append(time)
        self.model.append(isEditting)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.changeTheme(self.theme)
        self.setupNavigationButton()
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> SettingModel {
        return self.model[indexPath.row]
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .time:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTimeTableViewCell.name, for: indexPath) as?
                    SettingTimeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            cell.timeChanged = { time in
                AppManager.shared.setTimeToPushNoti(hour: time.hour, minute: time.minute)
            }
            return cell
        case .isEditting:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchTableViewCell.name, for: indexPath) as?
                    SettingSwitchTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            cell.switchChanged = { value in
                AppManager.shared.setIsEdittingValue(isEditting: value)
            }
            return cell
        }
    }
}
