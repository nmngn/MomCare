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
        let url = URLs.getAllUrl + idAdmin
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idUser: String, type: Alamofire.HTTPMethod) { //getOne
        let url = URLs.userUrl + idUser
        let body: [String: Any] = [:]
        super.init(url: url, requestType: type, body: body)
    }
    
    required init(idAdmin: String, name: String, address: String, momBirth: String, numberPhone: String,
                  height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                  imagePregnant: String) { //create
        let url = URLs.userUrl + idAdmin
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
            "imagePregnant": imagePregnant]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(idUser: String) { //delete
        let url = URLs.userUrl + idUser
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .delete, body: body)
    }
    
    required init(idUser: String, name: String, address: String, momBirth: String, numberPhone: String,
                  height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                  imagePregnant: String) { //update
        let url = URLs.userUrl + idUser
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
            "imagePregnant": imagePregnant]
        super.init(url: url, requestType: .put, body: body)
    }
    
    required init(idUser: String, isStar: Bool) {
        let url = URLs.userUrl + idUser
        let body: [String: Any] = [
            "isStar": isStar]
        super.init(url: url, requestType: .put, body: body)
    }
    
}
