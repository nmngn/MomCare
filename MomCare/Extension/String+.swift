//
//  String+.swift
//  MomCare
//
//  Created by Nam Ngây on 07/07/2021.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}
