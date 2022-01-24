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
}

final class UserLogIn {
    var userNumberPhone = ""
    var idAdmin = ""
}

struct URLs {
    private static var baseUrl = "https://localhost:3001/"
    
    var createAdmin = baseUrl + "admin/"
    var updateAdmin = baseUrl + "admin/"
    
    var createUser = baseUrl + "user/"
    var updateUser = baseUrl + "user/"
    var deleteUser = baseUrl + "user/"
    var getAllUser = baseUrl + "user/"
    var getOneUser = baseUrl + "user/"
    
    var createNote = baseUrl + "note/"
    var deleteNote = baseUrl + "note/"
    var getOneNote = baseUrl + "note/"
    var getAllNote = baseUrl + "note/"
}
