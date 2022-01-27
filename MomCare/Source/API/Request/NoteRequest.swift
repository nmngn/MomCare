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
        let url = URLs.noteUrl
        let body: [String: Any] = [
            "idUser": idUser,
            "time": time,
            "image": image
        ]
        super.init(url: url, requestType: .post, body: body)
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
        let url = URLs.getAllNote
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(_ idUser: String) {
        let url = URLs.deleteNotes + idUser
        let body: [String: Any] = [:]
        super.init(url: url, requestType: .delete, body: body)
    }
}
