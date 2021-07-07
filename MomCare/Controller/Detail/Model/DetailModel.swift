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

struct DetailModel {
    var type: DetailType
    var title = ""
    var value = ""
    var showCalendar = false
    var image: UIImage?
    var date = ""
    var placeHolder = ""
    
    init(type: DetailType) {
        self.type = type
    }
}
