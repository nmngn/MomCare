//
//  SortListTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class SortListTableViewCell: UITableViewCell {

    var selectSoft : (() ->())?
    @IBOutlet weak var softTitle: UILabel!
    
    func setupTitle(title: String, contrastColor: UIColor) {
        softTitle.text = title
        softTitle.textColor = contrastColor
    }
    
    @IBAction func selectSort(_ sender: UIButton) {
        selectSoft?()
    }
}
