//
//  AccountTableViewCell.swift
//  MomCare
//
//  Created by Nam Nguyễn on 13/07/2022.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet private var imgIcon: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    func setupData(data: AccountModel) {
        imgIcon.image = data.image
        titleLabel.text = data.title
    }
    
}
