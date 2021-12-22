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
    @objc dynamic var avatar = ""
    @objc dynamic var imagePregnant = ""
    dynamic var historyPicture = List<HistoryNote>()
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.address = address
        model.numberPhone = numberPhone
  //      model.avatarImage = loadImageFromDiskWith(fileName: avatarImage)
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = dateCalculate
        model.babyAge = babyDateBorn
        model.note = note
 //       model.imagePregnant = loadImageFromDiskWith(fileName: imagePregnant)
        return model
    }

}

class HistoryNote: Object {
    @objc dynamic var time = ""
    @objc dynamic var image: NSData?
}
