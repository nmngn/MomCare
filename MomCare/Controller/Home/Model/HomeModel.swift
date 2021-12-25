//
//  HomeModel.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

enum HomeType {
    case badge
    case title
    case sort
    case infoUser
}

struct HomeModel {
    var type: HomeType
    var title = ""
    var description = ""
    var image: UIImage?
    var backgroundColor: UIColor?
    
    var id = 0
    var avatarImage: NSData?
    var name = ""
    var address = ""
    var momBirth = ""
    var numberPhone = ""
    var height = ""
    var dateCalculate = ""
    var babyAge = ""
    var note = ""
    var imagePregnant: NSData?
    var dateSave = ""
    
    init(type: HomeType) {
        self.type = type
    }
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = id
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImage = UIImage(data: Data(referencing: avatarImage ?? NSData()))
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = dateCalculate
        model.babyAge = babyAge
        model.note = note
        model.imagePregnant = UIImage(data: Data(referencing: imagePregnant ?? NSData()))
        return model
    }
}
