//
//  NotificationModel.swift
//  MomCare
//
//  Created by Nam Ngây on 29/12/2021.
//

import Foundation
import UIKit

struct NotificationModel: Hashable {
    var name = ""
    var babyDateBorn = ""
    var dateCalculate = ""
    var id = ""
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

