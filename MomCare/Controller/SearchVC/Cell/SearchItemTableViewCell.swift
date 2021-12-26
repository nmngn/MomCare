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
            if let avatar = model.avatar {
                self.avatarUser.image = UIImage(data: Data(referencing: avatar))
            } else {
                self.avatarUser.image = UIImage(named: "avatar_placeholder")
            }
        }

        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        if model.updateTime(dateString: model.babyDateBorn).isEmpty {
            babyAgeLabel.text = "Chưa cập nhật"
            dateBornLabel.text = "Chưa cập nhật"
        } else {
            babyAgeLabel.text = model.updateTime(dateString: model.babyDateBorn)
            dateBornLabel.text = model.babyDateBorn
        }

    }

}
