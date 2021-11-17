//
//  HistoryModel.swift
//  MomCare
//
//  Created by Nam Ngây on 09/07/2021.
//

import Foundation

enum HistoryType {
    case add
    case title
    case cell
}

struct HistoryModel {
    var type: HistoryType
    var title = ""
    
    init(type: HistoryType) {
        self.type = type
    }
}
