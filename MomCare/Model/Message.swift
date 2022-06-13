//
//  Message.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import Foundation
import UIKit

enum MessageType {
    case current
    case other
}

struct Message {
    var type: MessageType = .current
    var sender = ""
    var body = ""
    var received = ""
    var time = ""
    var textAlignment: NSTextAlignment = .right
    var color = UIColor(named: Constant.BrandColors.purple)
}
