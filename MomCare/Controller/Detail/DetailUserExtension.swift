//
//  DetailUserExtension.swift
//  MomCare
//
//  Created by NamNT1 on 21/11/24.
//
import UIKit

extension DetailUserViewController {
    func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setNotiTime() {
        self.showAlertWithFieldsAndDatePicker()
    }
    
    @objc func removeUser() {
        if self.currentModel.dateSave.isEmpty {
            self.showConfirmAlert(title: Constant.Text.notification,
                                  message: Constant.Text.patientNotSave,
                                  confirmTitle: Constant.Text.saveIt
            ) {[weak self] in
                self?.saveData()
            }
        } else {
            self.showConfirmAlert(title: Constant.Text.notification, message: Constant.Text.removeUser) {[weak self] in
                self?.deleteUser()
            }
        }
    }
    
    func modelIndexPath(indexPath: IndexPath) -> DetailModel {
        return self.model[indexPath.row]
    }
    
    func deleteUser() {
        let currentUser = realm.objects(User.self).filter("idUser == %@", currentModel.id).toArray()
        let noteOfUser = realm.objects(HistoryNote.self).filter("idUser == %@", currentModel.id).toArray()
        try! self.realm.safeWrite {[weak self] in
            self?.realm.delete(currentUser)
            self?.realm.delete(noteOfUser)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupNavigationButton() {
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
        
        let isEnable = !currentModel.dateSave.isEmpty && isEnableRightButton
        
        let deleteButton = UIBarButtonItem(image: isEnable ?
                                        UIImage(systemName: "trash")?.toHierachicalImage() : UIImage(systemName: "trash"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(removeUser))
        
        let notiButton = UIBarButtonItem(image: isEnable ?
                                         UIImage(systemName: "bell")?.toHierachicalImage() : UIImage(systemName: "bell"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(setNotiTime))
        
        deleteButton.isEnabled = isEnable
        notiButton.isEnabled = isEnable
        
        navigationItem.rightBarButtonItems = [deleteButton, notiButton]
    }
    
    func showAlertWithFieldsAndDatePicker() {
        let alert = UIAlertController(title: "Nhập nội dung thông báo", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nhập tiêu đề"
            textField.keyboardType = .default
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Nhập nội dung"
            textField.keyboardType = .default
        }
        
        let submitAction = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            let firstField = alert.textFields?[0].text ?? ""
            let secondField = alert.textFields?[1].text ?? ""
            
            self?.infoNotification = (title: firstField, content: secondField)
            self?.openDate(isSetNotification: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }

    func saveData() {
        self.saveInfoUser()
    }
    
    func openDate(isSetNotification: Bool = false) {
        let vc = PopupCalendarViewController.init(nibName: PopupCalendarViewController.className, bundle: nil)
        vc.selectDate = { [weak self] date in
            guard let self = self else { return }
            if !isSetNotification {
                self.currentModel.babyAge = date
                self.calculateBabyAge(dateString: date)
                self.setupData()
                let indexPath = IndexPath(row: 7, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                self.scheduleNotifications(time: date)
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    func calculateBabyAge(dateString: String) {
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        dateFormatter.dateFormat = Constant.Text.dateFormat
        let date = dateFormatter.date(from:dateString)
        guard let timeLast = date?.millisecondsSince1970 else { return }
        let timeToday = todayDate.millisecondsSince1970
        let result = timeLast - timeToday
        self.changeMilisToWeek(milis: result)
    }
    
    func changeMilisToWeek(milis: Int64) {
        let toDay = milis / 86400000
        let ageDay = 280 - Int(toDay)
        let week = Int(ageDay / 7)
        let day = Int(ageDay % 7)
        self.currentModel.dateCalculate = week < 10 ?  "0\(week)W \(day)D" : "\(week)W \(day)D"
    }
    
    func scheduleNotifications(time: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = self.infoNotification.title
        content.body = self.infoNotification.content
        content.sound = .default

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.Text.dateFormat

        guard let date = dateFormatter.date(from: time) else { return }
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let (hour, minute) = AppManager.shared.getTime()

        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = UUID().uuidString.lowercased()
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) {[weak self] error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                DispatchQueue.main.async {
                    if let currentUser = self?.realm.objects(User.self).first(where: {$0.idUser == self?.currentModel.id}) {
                        try! self?.realm.safeWrite {
                            currentUser.setNotificationTime = 
                            "\(dateComponents.day ?? 0)/\(dateComponents.month ?? 0)/\(dateComponents.year ?? 0) \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)"
                            
                            self?.showNoticeAlert(title: Constant.Text.notification, message: "Cập nhật thành công", completion: {[weak self] in
                                self?.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
            }
        }
    }
}
