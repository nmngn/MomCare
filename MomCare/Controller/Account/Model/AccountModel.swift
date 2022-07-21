//
//  AccountModel.swift
//  MomCare
//
//  Created by Nam Nguyễn on 13/07/2022.
//

import Foundation
import UIKit

enum AccountType {
    case setting
    case notiSetting
}

struct AccountModel {
    var type: AccountType?
    var image: UIImage?
    var title = ""
}
