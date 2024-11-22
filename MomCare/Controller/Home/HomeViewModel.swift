//
//  HomeViewModel.swift
//  MomCare
//
//  Created by NamNT1 on 21/11/24.
//

import RxRelay
import RealmSwift
import NotificationCenter

enum SortType {
    case name
    case date
    case age
    case normal
    
    func toText() -> String {
        switch self {
        case .name: return Constant.Text.sortName
        case .age: return Constant.Text.sortAge
        case .date:  return Constant.Text.sortDate
        default: return ""
        }
    }
}

class HomeViewModel {
    
    let realm = try! Realm()
    
    let listUserData = BehaviorRelay<[User]>(value: [])
    let listHomeData = BehaviorRelay<[HomeModel]>(value: [])
    let listNotificationData = BehaviorRelay<[NotificationModel]>(value: [])
    let sortType = BehaviorRelay<SortType>(value: .normal)
    let localNotificationCenter: UNUserNotificationCenter
    
    init(localNotificationCenter: UNUserNotificationCenter = .current()) {
        self.localNotificationCenter = localNotificationCenter
    }
    
    func getListUserData() {
        let list = realm.objects(User.self).toArray()
        self.listUserData.accept(list)
    }
    
    func getListHomeData() {
        let listUser = self.listUserData.value
        var model = [HomeModel]()
        let newList = listUser.filter ({ user in
            if !user.babyDateBorn.isEmpty {
                let startIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 3)
                let endIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 4)
                let data = String(user.babyDateBorn[startIndex...endIndex])
                let result = Int(data) ?? 0 == getCurrentMonth()
                return result
            }
            return false
        })
        
        let badge = HomeModel(type: .badge)
        let addUser = HomeModel(type: .addUser)
        
        var header1 = HomeModel(type: .title)
        header1.title = Constant.Text.patientInMonth + "(\(newList.count))"
        
        var infoCell = HomeModel(type: .infoUser)
        let sort = HomeModel(type: .sort)
        
        var header2 = HomeModel(type: .title)
        header2.title = Constant.Text.allPatient + "(\(listUser.count))"
        
        model.append(badge)
        model.append(addUser)
        model.append(header1)
        
        for i in 0..<newList.count {
            infoCell.id = newList[i].idUser
            infoCell.avatarImage = newList[i].avatar
            infoCell.babyAge = newList[i].babyDateBorn
            infoCell.name = newList[i].name
            infoCell.dateSave = newList[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: newList[i].babyDateBorn)
            infoCell.isStar = newList[i].isStar
            infoCell.notificationTime = newList[i].setNotificationTime
            model.append(infoCell)
        }
        
        model.append(header2)
        if !listUser.isEmpty {
            model.append(sort)
        }
        
        for i in 0..<listUser.count {
            infoCell.id = listUser[i].idUser
            infoCell.avatarImage = listUser[i].avatar
            infoCell.babyAge = listUser[i].babyDateBorn
            infoCell.name = listUser[i].name
            infoCell.dateSave = listUser[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: listUser[i].babyDateBorn)
            infoCell.isStar = listUser[i].isStar
            model.append(infoCell)
        }
        self.listHomeData.accept(model)
    }
    
    func getUserToPushNoti() {
        var notiModel = [NotificationModel]()
        let listUser = self.listUserData.value
        let newList = listUser.filter ({ user in
            let text = updateTime(dateString: user.babyDateBorn)
            if !text.isEmpty {
                let wStartIndex = text.index(text.startIndex, offsetBy: 0)
                let wEndIndex = text.index(text.startIndex, offsetBy: 1)
                let weekData = String(text[wStartIndex...wEndIndex])
                
                let wResult = Int(weekData) ?? 0 >= 38
                return wResult
            }
            return false
        })
        for user in newList {
            notiModel.append(user.convertToNotiModel())
        }
        self.listNotificationData.accept(notiModel)
        self.sendNotification(noti: listNotificationData.value)
    }
    
    func sendNotification(noti: [NotificationModel]) {
        let application = UIApplication.shared
        let notificationContent = UNMutableNotificationContent()
        if noti.count == 1 {
            notificationContent.title = Constant.Text.notificationAbout + "\(noti.first?.name ?? "")"
            notificationContent.body =
            "Chú ý: \(noti.first?.name ?? "") đã bước vào tháng cuối( \(noti.first?.dateCalculate ?? ""))\nCần chú ý !"
        } else {
            notificationContent.title = Constant.Text.notificationAbout + "\(listNotificationData.value.count) sản phụ tháng cuối"
            notificationContent.body =
            "Chú ý: \(listNotificationData.value.count) sản phụ đã bước vào tháng cuối \nCần chú ý !"
        }
        application.applicationIconBadgeNumber = noti.count
        
        if let url = Bundle.main.url(forResource: Constant.Text.dune,
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: Constant.Text.dune,
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var date = DateComponents()
        (date.hour, date.minute) = AppManager.shared.getTime()
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: Constant.Text.notificationEn,
                                            content: notificationContent,
                                            trigger: trigger)
        
        if !noti.isEmpty {
            localNotificationCenter.add(request) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
    }

    func saveStarStatus(id: String,_ isStar: Bool) {
        guard let selectedUser = self.realm.objects(User.self).first(where: {$0.idUser == id}) else { return }
        try! self.realm.write {
            selectedUser.isStar = isStar
        }
        self.getListUserData()
    }
}
