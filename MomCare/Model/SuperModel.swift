//
//  SuperModel.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation
import ObjectMapper

class SuperAdmin: Mappable {
    var admins: [Admin]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        admins <- map["data"]
    }
}

class SuperUser: Mappable {
    var users: [User]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        users <- map["data"]
    }
}

class SuperNote: Mappable {
    var notes: [HistoryNote]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        notes <- map["data"]
    }
}
