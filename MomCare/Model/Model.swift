//
//  RealmModel.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import AlamofireObjectMapper

struct Admin: Mappable {
    var idAdmin = ""
    var name = ""
    var email = ""
    var address = ""
    var image = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idAdmin <- map["id"]
        name <- map["name"]
        email <- map["email"]
        address <- map["address"]
        image <- map[image]
    }
}

struct User : Mappable {
    var idAdmin = ""
    var idUser = ""
    var name = ""
    var address = ""
    var momBirth = ""
    var numberPhone = ""
    var height = ""
    var babyDateBorn = ""
    var dateSave = ""
    var note = ""
    var avatar = ""
    var imagePregnant = ""
    var isStar = false
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idAdmin <- map["idAdmin"]
        idUser <- map["id"]
        name <- map["name"]
        address <- map["address"]
        momBirth <- map["momBirth"]
        numberPhone <- map["numberPhone"]
        babyDateBorn <- map["babyDateBorn"]
        height <- map["height"]
        dateSave <- map["dateSave"]
        note <- map["note"]
        avatar <- map["avatar"]
        imagePregnant <- map["imagePregnant"]
        isStar <- map["isStar"]
        
    }
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = idUser
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImage = UIImage(data: Data(referencing: avatar ?? NSData()))
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = updateTime()
        model.babyAge = babyDateBorn
        model.note = note
        model.imagePregnant = UIImage(data: Data(referencing: imagePregnant ?? NSData()))
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

struct HistoryNote: Mappable {
    var idNote = ""
    var idUser = ""
    var time = ""
    var image = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idNote <- map["id"]
        idUser <- map["idUser"]
        time <- map["time"]
        image <- map["image"]
    }
}
