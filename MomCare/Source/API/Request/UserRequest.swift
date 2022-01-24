//
//  UserRequest.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class UserRequest: BaseRequest {
    
    required init(idAdmin: String) { //getAll
        let url = String(format: URLs.getAllUser, arguments: idAdmin)
        let body: [String: Any] = []
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idUser: String) { //getOne
        let url = String(format: URLs.getOneUser, arguments: idUser)
        let body: [String: Any] = []
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idAdmin: String, name: String, address: String, momBirth: String, numberPhone: String,
                  height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                  imagePregnant: String, isStar: Bool) { //create
        let url = String(format: URLs.createUser, arguments: idAdmin)
        let body: [String: Any] = [
            "name": name,
            "address": address,
            "momBirth": momBirth,
            "numberPhone": numberPhone,
            "height": height,
            "babyDateBorn": babyDateBorn,
            "dateSave": dateSave,
            "note": note,
            "avatar": avatar,
            "imagePregnant": imagePregnant,
            "isStar": isStar]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(idUser: String) { //delete
        let url = String(format: URLs.deleteUser, arguments: idUser)
        let body: [String: Any] = []
        super.init(url: url, requestType: .delete, body: body)
    }
    
    required init(idUser: String, name: String, address: String, momBirth: String, numberPhone: String,
                  height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                  imagePregnant: String, isStar: Bool) { //update
        let url = String(format: URLs.updateUser, arguments: idUser)
        let body: [String: Any] = [
            "name": name,
            "address": address,
            "momBirth": momBirth,
            "numberPhone": numberPhone,
            "height": height,
            "babyDateBorn": babyDateBorn,
            "dateSave": dateSave,
            "note": note,
            "avatar": avatar,
            "imagePregnant": imagePregnant,
            "isStar": isStar]
        super.init(url: url, requestType: .put, body: body)
    }
    
}
