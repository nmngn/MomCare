//
//  SortListTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class SortListTableViewCell: UITableViewCell {

    var selectSoft : (() ->())?
    
    @IBAction func selectSort(_ sender: UIButton) {
        selectSoft?()
    }
}
