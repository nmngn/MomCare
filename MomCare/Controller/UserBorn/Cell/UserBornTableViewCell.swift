//
//  UserBornTableViewCell.swift
//  MomCare
//
//  Created by NamNT1 on 30/11/24.
//

import UIKit

class UserBornTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
    }
    
    func setupData(model: UserBornModel) {
        titleLabel.text = "Họ và tên: \(model.name)"
        descriptionLabel.text = "Ngày dự sinh: \(model.babyDateBorn)"
    }
}
