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
    case smallUser
    case biggerUser
}

struct HomeModel {
    var type: HomeType
    var title = ""
    var description = ""
    var image: UIImage?

    init(type: HomeType) {
        self.type = type
    }
}
