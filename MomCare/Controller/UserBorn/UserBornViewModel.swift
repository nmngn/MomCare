//
//  UserBornViewModel.swift
//  MomCare
//
//  Created by NamNT1 on 30/11/24.
//

import Foundation
import RealmSwift
import RxRelay

class UserBornViewModel {
    
    let listUser = BehaviorRelay<[UserBornModel]>(value: [])
    var defaultListUser = [UserBornModel]()
    let realm = try! Realm()
    
    init() {
        getListUser()
    }
    
    func getListUser() {
        let data = self.realm.objects(UserBornModel.self).toArray()
        defaultListUser = data
        listUser.accept(data)
    }
}
