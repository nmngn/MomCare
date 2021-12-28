//
//  HomeTitleTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class HomeTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    func setupData(model: HomeModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.contrastColor
    }
    
    func setupData(model: HistoryModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.contrastColor
    }
    
}
