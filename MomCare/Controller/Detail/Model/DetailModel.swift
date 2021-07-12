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
    case babyImage
    case historyPicture
    case dateSave
}

struct DetailModel {
    var type: DetailType
    var title = ""
    var value = ""
    var showCalendar = false
    var image: UIImage?
    var date = ""
    var placeHolder = ""
    var dataType: DataType
    
    init(type: DetailType, dataType: DataType) {
        self.type = type
        self.dataType = dataType
    }
}
