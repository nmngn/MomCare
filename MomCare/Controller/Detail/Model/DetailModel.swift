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
    
    func compressNSData(image: UIImage, type: UserChoice) -> NSData {
        if type == .mom {
            guard let imgData = image.jpegData(compressionQuality: 0.9) else { return NSData() }
            return NSData(data: imgData)
        } else {
            guard let imgData = image.pngData() else { return NSData()}
            return NSData(data: imgData)
        }
    }
}
