//
//  UserModel.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import UIKit

enum UserType {
    case general
    case data
    case more
}

struct UserInfo {
    var type: UserType?
    var title = ""
    var value = ""
    var avatarImage: UIImage?
    var name = ""
    var address = ""
    var momBirth = ""
    var numberPhone = ""
    var height = ""
    var dateCalculate = ""
    var babyAge = ""
    var note = ""
    var imagePregnant: UIImage?
    var dateSave = ""
}
