//
//  NoteRequest.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class NoteRequest: BaseRequest {
    required init(idUser: String, time: String, image: String) { //create
        let url = URLs.noteUrl + idUser
        let body: [String: Any] = [
            "time": time,
            "image": image
        ]
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idNote: String) { //delete
        let url = URLs.noteUrl + idNote
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .delete, body: body)
    }
    
    required init(idNote: String, type: Alamofire.HTTPMethod) { //getOne
        let url = URLs.noteUrl + idNote
        let body: [String: Any] = [:]
        super.init(url: url, requestType: type, body: body)
    }
    
    required init(idUser: String) { //getAll
        let url = URLs.noteUrl + idUser
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .get, body: body)
    }
}
