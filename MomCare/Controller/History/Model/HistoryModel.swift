//
//  HistoryModel.swift
//  MomCare
//
//  Created by Nam Ngây on 09/07/2021.
//

import Foundation
import UIKit

enum HistoryType {
    case add
    case title
    case cell
}

struct HistoryModel {
    var type: HistoryType
    var idNote = ""
    var idUser = ""
    var time = ""
    var dataImage = ""
    var title = ""
    
    init(type: HistoryType) {
        self.type = type
    }
}
