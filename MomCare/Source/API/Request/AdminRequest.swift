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
        let url = URL(string: URLs.createAdmin)
        let body: [String: Any] = [
            "number": numberPhone
        ]
        super.init(url: url, requestType: .post, body: body)
    }
    
    required init(idAdmin: String, avatar: String, name: String, address: String, email: String) { //update
        let url = String(format: URLs.updateAdmin, arguments: idAdmin)
        let body: [String: Any] = [
            "name": name,
            "avatar": avatar,
            "address": address,
            "email": email
        ]
        super.init(url: url, requestType: .put, body: body)
    }

}
