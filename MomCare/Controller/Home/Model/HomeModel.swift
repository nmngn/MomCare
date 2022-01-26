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
    case addUser
}

struct HomeModel {
    var type: HomeType
    var title = ""
    var description = ""
    var image: UIImage?
    var backgroundColor: UIColor?
    
    var id = ""
    var avatarImage = ""
    var name = ""
    var address = ""
    var momBirth = ""
    var numberPhone = ""
    var height = ""
    var dateCalculate = ""
    var babyAge = ""
    var note = ""
    var imagePregnant = ""
    var dateSave = ""
    var isStar = false
    var contrastColor = UIColor()
    
    init(type: HomeType) {
        self.type = type
    }
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
        model.id = id
        model.address = address
        model.numberPhone = numberPhone
        model.avatarImage = loadImageFromDiskWith(fileName: avatarImage)
        model.name = name
        model.momBirth = momBirth
        model.height = height
        model.dateSave = dateSave
        model.dateCalculate = dateCalculate
        model.babyAge = babyAge
        model.note = note
        model.imagePregnant = loadImageFromDiskWith(fileName: imagePregnant)
        model.contrastColor = contrastColor
        return model
    }
}
