//
//  AdminRequest.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class AdminRequest: BaseRequest {
    required init(numberPhone: String) { //create
        let url = URLs.adminUrl
        let body: [String: Any] = [
            "numberPhone": numberPhone
        ]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(idAdmin: String, avatar: String, name: String, address: String, email: String) { //update
        let url = URLs.adminUrl + idAdmin
        let body: [String: Any] = [
            "name": name,
            "image": avatar,
            "address": address,
            "email": email
        ]
        super.init(url: url, requestType: .put, body: body)
    }
    
    required init(idAdmin: String) { //get One
        let url = URLs.adminUrl + idAdmin
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .get, body: body)
    }

}
