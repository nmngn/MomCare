//
//  HistoryViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 09/07/2021.
//

import UIKit
import RealmSwift
import PopupDialog

class HistoryViewController: UIViewController {

    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var model = [HistoryModel]()
    var idUser = ""
    var listHistory: [HistoryNote]? {
        didSet {
            setupData()
        }
    }
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTheme(self.theme)
        self.configView()
        self.setupBackButton()
        self.getListHistory()
        self.title = Constant.Text.historyVC
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.changeTheme(theme)
        self.setupBackButton()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    func setupBackButton() {
      self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getListHistory() {
        self.listHistory = realm.objects(HistoryNote.self).filter("idUser == %@", idUser).toArray()
        self.tableView.reloadData()
    }
    
    func configView() {
        self.tableView.do {
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
        self.model.removeAll()
        let add = HistoryModel(type: .add)
        
        var title = HistoryModel(type: .title)
        title.title = Constant.Text.noted + "( \(self.listHistory?.count ?? 0))"
        
        var cell = HistoryModel(type: .cell)
        
        model.append(add)
        model.append(title)
        
        guard let list = self.listHistory else { return }
        for item in list {
            cell.title = item.title
            cell.time = item.time
            cell.dataImage = item.image
            cell.idNote = item.idNote
            cell.idUser = item.idUser
            model.append(cell)
        }
        self.tableView.reloadData()
    }

    func modelIndexPath(indexPath: IndexPath) -> HistoryModel {
        return self.model[indexPath.row]
    }
    
    func removeNote(id: String) {
        guard let currentNote = realm.objects(HistoryNote.self).filter("idNote == %@", id).toArray().first else { return  }
        
        try! self.realm.write({
            self.realm.delete(currentNote)
        })
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
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
        model = self.modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .add:
            self.openLibararies()
        case .cell:
            let vc = ShowImageDetailViewController.init(nibName: ShowImageDetailViewController.className, bundle: nil)
            vc.imageData = model.dataImage
            vc.titleData = model.title
            vc.time = model.time
            present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var model: HistoryModel
        model = self.modelIndexPath(indexPath: indexPath)
        switch model.type {
        case .cell:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            self.removeNote(id: model[indexPath.row].idNote)
            self.model.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
            self.getListHistory()
        }
    }
    
}

extension HistoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openLibararies() {
        let alert = UIAlertController(title: "Select Photo Type", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func openMedia(type: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = type
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picker.dismiss(animated: true) {
                let vc = TitleNoteViewController.init(nibName: TitleNoteViewController.className, bundle: nil)
                vc.saveNote = { [weak self] title in
                    self?.saveData(imageData: image, title: title)
                }
                let popup = PopupDialog(viewController: vc,
                                        buttonAlignment: .horizontal,
                                        transitionStyle: .fadeIn,
                                        tapGestureDismissal: true,
                                        panGestureDismissal: false)
                self.present(popup, animated: true, completion: nil)
            }
        }
        
    }
}

extension HistoryViewController {
    func saveData(imageData: UIImage, title: String) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.Text.dateFormatDetail
        let date = Date()
        let dateString = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: ".")
        
        let imageAddress = saveImage(imageName:
        "note_\(dateString)", image: imageData, type: .baby)
        
        do {
            self.realm.beginWrite()
            let currentNote = HistoryNote()
            currentNote.idUser = self.idUser
            currentNote.time = dateString
            currentNote.image = imageAddress
            currentNote.idNote = NSUUID().uuidString.lowercased()
            currentNote.title = title
            
            try? self.realm.commitWrite()
            try? self.realm.safeWrite {
                self.realm.add(currentNote)
            }
        }
        self.getListHistory()
    }
}
