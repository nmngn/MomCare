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
    
    func setupData(model: NotificationModel, contrastColor: UIColor) {
        titleLabel.text = model.name
        timeLabel.text = model.babyDateBorn
        descriptionLabel.text = model.dateCalculate
        
        titleLabel.textColor = contrastColor
        descriptionLabel.textColor = contrastColor
        if contrastColor == .black {
            subView.backgroundColor = UIColor(red: 0.45, green: 0.66, blue: 0.85, alpha: 1.00)
        } else {
            subView.backgroundColor = UIColor(red: 0.36, green: 0.30, blue: 0.59, alpha: 1.00)
        }
    }
    
}
