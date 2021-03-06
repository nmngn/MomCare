//
//  SearchItemTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dayCreateLabel: UILabel!
    @IBOutlet weak var babyAgeLabel: UILabel!
    @IBOutlet weak var dateBornLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
        subView.makeBorderColor()
    }
    
    func setupData(model: User) {
        DispatchQueue.main.async {
            if model.avatar != "" {
                self.avatarUser.image = loadImageFromDiskWith(fileName: model.avatar)
            } else {
                self.avatarUser.image = UIImage(named: "avatar_placeholder")
            }
        }

        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        if model.updateTime().isEmpty {
            babyAgeLabel.text = "Chưa cập nhật"
            dateBornLabel.text = "Chưa cập nhật"
        } else {
            babyAgeLabel.text = model.updateTime()
            dateBornLabel.text = model.babyDateBorn
        }
        
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = UIColor(red: 0.45, green: 0.66, blue: 0.85, alpha: 1.00)
        } else {
            subView.backgroundColor = UIColor(red: 0.36, green: 0.30, blue: 0.59, alpha: 1.00)
        }
    }
}
