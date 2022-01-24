//
//  NoteRequest.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import Alamofire

class NoteRequest: BaseRequest {
    required init(idUser: String) { //create
        let url = String(format: URLs.createNote, arguments: idUser)
        let body: [String: Any] = []
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idNote: String) { //delete
        let url = String(format: URLs.deleteNote, arguments: idNote)
        let body: [String: Any] = []
        super.init(url: url, requestType: .delete, body: body)
    }
    
    required init(idNote: String) { //getOne
        let url = String(format: URLs.getOneNote, arguments: idNote)
        let body: [String: Any] = []
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(idUser: String) { //getAll
        let url = String(format: URLs.getAllNote, arguments: idUser)
        let body: [String: Any] = []
        super.init(url: url, requestType: .get, body: body)
    }
}
