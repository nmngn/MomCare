//
//  Model.swift
//  MomCare
//
//  Created by NamNT1 on 27/09/2023.
//

import Foundation

enum SettingType {
    case time
    case isEditting
}

struct SettingModel {
    var type: SettingType
    var title = ""
    var time = ""
    var isEditting = true
    
    init(type: SettingType) {
        self.type = type
    }
}
