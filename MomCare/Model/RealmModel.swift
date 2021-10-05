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
    @objc dynamic var dob = ""
    @objc dynamic var numberPhone = ""
    @objc dynamic var height = ""
    @objc dynamic var dateCalculate = ""
    @objc dynamic var dateSave = ""
    @objc dynamic var babyAge = ""
    @objc dynamic var note = ""
    @objc dynamic var momImage: NSData?
    @objc dynamic var babyImage: NSData?
    dynamic var historyPicture = List<HistoryNote>()
}

class HistoryNote: Object {
    @objc dynamic var time = ""
    @objc dynamic var image: NSData?
}
