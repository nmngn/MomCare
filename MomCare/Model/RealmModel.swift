//
//  RealmModel.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit
import RealmSwift

class User: Object {
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var momBirth = ""
    @objc dynamic var numberPhone = ""
    @objc dynamic var height = ""
    @objc dynamic var babyDateBorn = ""
    @objc dynamic var dateCalculate = ""
    @objc dynamic var dateSave = ""
    @objc dynamic var note = ""
    @objc dynamic var avatar: NSData?
    @objc dynamic var imagePregnant: NSData?
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImage = UIImage(data: Data(referencing: avatar ?? NSData()))
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = dateCalculate
        model.babyAge = babyDateBorn
        model.note = note
        model.imagePregnant = UIImage(data: Data(referencing: imagePregnant ?? NSData()))
        return model
    }

}

class HistoryNote: Object {
    @objc dynamic var identifyUser = ""
    @objc dynamic var time = ""
    @objc dynamic var image: NSData?
}
