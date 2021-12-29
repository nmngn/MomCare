//
//  HistoryViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 09/07/2021.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {

    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var model = [HistoryModel]()
    var identifyUser = 0
    let realm = try! Realm()
    var listHistory: [HistoryNote]? {
        didSet {
            setupData()
            self.tableView.reloadData()
        }
    }
    var contrastColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupBackButton()
        getListHistory()
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        self.title = "Lịch sử ghi chú"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        changeTheme()
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
    
    func getListHistory() {
        let result = realm.objects(HistoryNote.self).toArray()
        let newList = result.filter({$0.identifyUser == self.identifyUser})
        if !newList.isEmpty {
            self.listHistory = newList
        }
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
        model.removeAll()
        var add = HistoryModel(type: .add)
        add.contrastColor = contrastColor
        
        var title = HistoryModel(type: .title)
        title.title = "Các ghi chú đã ghi (\(self.listHistory?.count ?? 0))"
        title.contrastColor = contrastColor
        
        var cell = HistoryModel(type: .cell)
        cell.contrastColor = contrastColor
        
        model.append(add)
        model.append(title)
        
        guard let list = self.listHistory else { return }
        for item in list {
            cell.title = item.time
            cell.dataImage = item.image
            model.append(cell)
        }
    }

    func modelIndexPath(indexPath: IndexPath) -> HistoryModel {
        return model[indexPath.row]
    }
    
    func removeNote(dateSave: String, index: Int) {
        let item = self.realm.objects(HistoryNote.self).filter("time = %@", dateSave)
        try! self.realm.write({
            self.realm.delete(item)
        })
        self.model.remove(at: index)
        self.getListHistory()
        self.tableView.reloadData()
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
            cell.setupData(model: model)
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
            cell.setupData(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: HistoryModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .add:
            openLibararies()
        case .cell:
            let vc = ShowImageDetailViewController.init(nibName: "ShowImageDetailViewController", bundle: nil)
            vc.imageData = model.dataImage
            transitionVC(vc: vc, duration: 0.5, type: .fromRight)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var model: HistoryModel
        model = modelIndexPath(indexPath: indexPath)
        switch model.type {
        case .cell:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var model: HistoryModel
        model = modelIndexPath(indexPath: indexPath)
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            removeNote(dateSave: model.title, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
}

extension HistoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openLibararies() {
        let alert = UIAlertController(title: "Select Photo Type".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library".localized, style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func openMedia(type: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = type
        vc.videoQuality = .typeMedium
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let image = image.jpegData(compressionQuality: 1) as NSData? else { return }
            self.saveData(imageData: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HistoryViewController {
    func saveData(imageData: NSData) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        do {
            realm.beginWrite()
            let history = HistoryNote()
            history.identifyUser = self.identifyUser
            history.time = dateString
            history.image = imageData

            try? realm.commitWrite()
            try? realm.safeWrite {
                realm.add(history)
            }
        }
        self.getListHistory()
        self.tableView.reloadData()
    }
}
