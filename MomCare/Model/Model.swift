//
//  RealmModel.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import RealmSwift

class User: Object {
    @Persisted var idUser = ""
    @Persisted var name = ""
    @Persisted var address = ""
    @Persisted var momBirth = ""
    @Persisted var numberPhone = ""
    @Persisted var height = ""
    @Persisted var babyDateBorn = ""
    @Persisted var dateSave = ""
    @Persisted var note = ""
    @Persisted var avatar = ""
    @Persisted var imagePregnant = ""
    @Persisted var isStar = false
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = idUser
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImage = loadImageFromDiskWith(fileName: avatar)
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = updateTime()
        model.babyAge = babyDateBorn
        model.note = note
        model.imagePregnant = loadImageFromDiskWith(fileName: imagePregnant)
        return model
    }
    
    func convertToNotiModel() -> NotificationModel {
        var model = NotificationModel()
        model.name = name
        model.babyDateBorn = babyDateBorn
        model.dateCalculate = updateTime()
        model.id = idUser
        return model
    }
    
    func updateTime() -> String {
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: babyDateBorn)
        guard let timeLast = date?.millisecondsSince1970 else { return ""}
        let timeToday = todayDate.millisecondsSince1970
        let result = timeLast - timeToday
        
        let toDay = result / 86400000
        let ageDay = 280 - Int(toDay)
        let week = Int(ageDay / 7)
        let day = Int(ageDay % 7)
        return week < 10 ?  "0\(week)W \(day)D" : "\(week)W \(day)D"
    }
    
}

class HistoryNote: Object{
    @Persisted var idNote = ""
    @Persisted var idUser = ""
    @Persisted var time = ""
    @Persisted var image = ""
}
