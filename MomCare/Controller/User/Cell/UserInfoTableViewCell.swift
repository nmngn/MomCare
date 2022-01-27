//
//  UserInfoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 23/01/2022.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberPhoneLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var babyAgeLabel: UILabel!
    @IBOutlet weak var babyCalculateLabel: UILabel!
    @IBOutlet weak var momBirthLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var imagePregnant: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var theme: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        theme.applyBlurEffect()
    }
    
    func setupData(model: UserInfo) {
        nameLabel.text = model.name
        addressLabel.text = model.address
        numberPhoneLabel.text = model.numberPhone
        heightLabel.text = model.height
        babyAgeLabel.text = model.babyAge
        babyCalculateLabel.text = model.dateCalculate
        momBirthLabel.text = model.momBirth
        noteLabel.text = model.note
        avatarImage.image = model.avatarImage ?? UIImage(named: "avatar_placeholder")
        
        if let image = model.imagePregnant {
            imagePregnant.image = image
            let ratio = image.size.width / image.size.height
            let newHeight = imagePregnant.frame.width / ratio
            imageHeightConstraint.constant = newHeight
            contentView.layoutIfNeeded()
        } else {
            imageHeightConstraint.constant = 0
        }
    }
}
