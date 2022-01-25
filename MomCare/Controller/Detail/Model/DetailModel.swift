//
//  DetailModel.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

enum DetailType {
    case avatar
    case general
    case info
    case age
    case note
    case photo
    case imagePregnant
}
enum DataType {
    case name
    case address
    case dob
    case numberPhone
    case height
    case dateCalculate
    case babyAge
    case note
    case momImage
    case imagePregnant
    case historyPicture
    case dateSave
}

struct DetailModel {
    var id = ""
    var type: DetailType?
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
    var placeHolder = ""
    var dataType: DataType?
    var contrastColor = UIColor()
    var isCall = false
    var isEnable = true
    
    func email(isAdmin: Bool = false) -> String {
        if isAdmin {
            return numberPhone + "@admin.com"
        }
        return numberPhone + "@user.com"
    }
    
    func changeImage(image: UIImage, type: UserChoice) -> NSData {
        if type == .baby {
            if let data = image.jpegData(compressionQuality: 1) as NSData? {
                return data
            }
        } else {
            if let data = image.jpegData(compressionQuality: 0) as NSData? {
                return data
            }
        }
        return NSData()
    }
}
