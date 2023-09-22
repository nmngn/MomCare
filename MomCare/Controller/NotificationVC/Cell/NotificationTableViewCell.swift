//
//  NotificationTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 29/12/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(model: NotificationModel) {
        titleLabel.text = "Họ và tên: \(model.name)"
        timeLabel.text = "Ngày dự sinh: \(model.babyDateBorn)"
        descriptionLabel.text = "Tuổi tuần thai: \(model.dateCalculate)"
        
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
    }
    
}
