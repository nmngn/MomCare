//
//  DetailUserExtension.swift
//  MomCare
//
//  Created by NamNT1 on 21/11/24.
//
import UIKit

extension DetailUserViewController {
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
        if !self.currentModel.name.isEmpty && !self.currentModel.address.isEmpty &&
            !self.currentModel.momBirth.isEmpty && !self.currentModel.height.isEmpty && !self.currentModel.numberPhone.isEmpty {
            self.saveInfoUser()
        } else {
            let alert = UIAlertController(title: Constant.Text.notification, message: Constant.Text.missingInfo, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: Constant.Text.understand, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
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
                        try! self?.realm.write{
                            currentUser.setNotificationTime = "\(dateComponents.day ?? 0)/\(dateComponents.month ?? 0)/\(dateComponents.year ?? 0) \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)"
                        }
                    }
                }
            }
        }
    }
}
