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
    
}

class HistoryNote: Object {
    @objc dynamic var time = ""
    @objc dynamic var image: NSData?
}
