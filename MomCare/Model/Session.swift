//
//  Session.swift
//  Spoon Master
//
//  Created by Nam Ngây on 10/01/2021.
//  Copyright © 2021 Nam Ngây. All rights reserved.
//

import Foundation
import UIKit

class Session {
    static var shared = Session()
    var userProfile = UserLogIn()
    var validPhone = "086|096|097|098|032|033|034|035|036|037|038|039|056|058|092|059|099|070|076|077|078|079|090|093|089|081|082|083|084|085|088|091|094"
    var isPopToRoot = false
}

final class UserLogIn {
    var userNumberPhone = ""
    var adminNumber = ""
    var idAdmin = ""
    var idUser = ""
}

struct URLs {
    private static var baseUrl = "http://localhost:3001/"
    
    static var adminUrl = baseUrl + "admin/"
    
    static var adminDatabByNumberPhone = adminUrl + "phone/"
    
    static var userUrl = baseUrl + "user/"
    
    static var getAllUser = userUrl + "all/"
    
    static var userDatabByNumberPhone = userUrl + "phone/"
    
    static var noteUrl = baseUrl + "note/"
    
    static var getAllNote = noteUrl + "all/"
    
    static var deleteNotes = noteUrl + "deleteNotes/"
}
