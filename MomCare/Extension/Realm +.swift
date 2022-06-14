//
//  Realm +.swift
//  MomCare
//
//  Created by Nam Ngây on 13/06/2022.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
