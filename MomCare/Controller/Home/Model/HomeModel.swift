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
    
    init(type: HomeType) {
        self.type = type
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        if fileName != "" {
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
            
            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
            
            if let dirPath = paths.first {
                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image
            }
        }
        return UIImage()
    }
    
    func convertToDetailModel() -> DetailModel {
        var model = DetailModel()
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
 //       model.imagePregnant = loadImageFromDiskWith(fileName: imagePregnant)
        return model
    }
}
