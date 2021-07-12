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
    @objc dynamic var momImage: UIImage?
    @objc dynamic var babyImage: UIImage?
    @objc dynamic var historyPicture: [[String: Any]]?
}


