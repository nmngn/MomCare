//
//  RealmModel.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import RealmSwift

class User: Object {
    @objc dynamic var idUser = ""
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var momBirth = ""
    @objc dynamic var numberPhone = ""
    @objc dynamic var height = ""
    @objc dynamic var babyDateBorn = ""
    @objc dynamic var dateSave = ""
    @objc dynamic var note = ""
    @objc dynamic var avatar = ""
    @objc dynamic var imagePregnant = ""
    @objc dynamic var isStar = false
    @objc dynamic var setNotificationTime = ""
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = idUser
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImagePath = avatar
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = updateTime(dateString: babyDateBorn)
        model.babyAge = babyDateBorn
        model.note = note
        model.imagePregnantPath = imagePregnant
        return model
    }
    
    func convertToNotiModel() -> NotificationModel {
        var model = NotificationModel()
        model.name = name
        model.babyDateBorn = babyDateBorn
        model.dateCalculate = updateTime(dateString: babyDateBorn)
        model.id = idUser
        return model
    }
    
    func copy(to target: UserBornModel) {
        target.idUser = self.idUser
        target.name = self.name
        target.address = self.address
        target.momBirth = self.momBirth
        target.numberPhone = self.numberPhone
        target.height = self.height
        target.babyDateBorn = self.babyDateBorn
        target.dateSave = self.dateSave
        target.note = self.note
        target.avatar = self.avatar
        target.imagePregnant = self.imagePregnant
        target.isStar = self.isStar
        target.setNotificationTime = self.setNotificationTime
    }
}

class HistoryNote: Object{
    @objc dynamic var idNote = ""
    @objc dynamic var idUser = ""
    @objc dynamic var time = ""
    @objc dynamic var image = ""
    @objc dynamic var title = ""
}

class UserBornModel: Object {
    @objc dynamic var idUser = ""
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var momBirth = ""
    @objc dynamic var numberPhone = ""
    @objc dynamic var height = ""
    @objc dynamic var babyDateBorn = ""
    @objc dynamic var dateSave = ""
    @objc dynamic var note = ""
    @objc dynamic var avatar = ""
    @objc dynamic var imagePregnant = ""
    @objc dynamic var isStar = false
    @objc dynamic var setNotificationTime = ""
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = idUser
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImagePath = avatar
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = updateTime(dateString: babyDateBorn)
        model.babyAge = babyDateBorn
        model.note = note
        model.imagePregnantPath = imagePregnant
        return model
    }
}
