//
//  HistoryViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 09/07/2021.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var model = [HistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupData()
        setupBackButton()
        self.title = "Lịch sử ghi chú"
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
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: AddPictureTableViewCell.self)
            $0.registerNibCellFor(type: NoteHistoryTableViewCell.self)
            $0.registerNibCellFor(type: HomeTitleTableViewCell.self)
        }
    }
    
    func setupData() {
        let add = HistoryModel(type: .add)
        var title = HistoryModel(type: .title)
        title.title = "Các ghi chú đã ghi"
        let cell = HistoryModel(type: .cell)
        
        model.append(add)
        model.append(title)
        model.append(cell)
    }

    func modelIndexPath(indexPath: IndexPath) -> HistoryModel {
        return model[indexPath.row]
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: HistoryModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .add:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddPictureTableViewCell.name, for: indexPath) as?
                    AddPictureTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTitleTableViewCell.name, for: indexPath) as?
                    HomeTitleTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        case .cell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteHistoryTableViewCell.name, for: indexPath) as?
                    NoteHistoryTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
