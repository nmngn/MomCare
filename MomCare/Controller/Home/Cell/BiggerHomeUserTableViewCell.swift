//
//  BiggerHomeUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class BiggerHomeUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dayCreateLabel: UILabel!
    @IBOutlet weak var babyAgeLabel: UILabel!
    @IBOutlet weak var dateBornLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    
    var isStar: ((Bool) -> ())?
    var model : HomeModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
        subView.makeBorderColor()
        buttonCheck.titleLabel?.text = ""
        buttonCheck.adjustsImageWhenHighlighted = false
        buttonCheck.adjustsImageWhenDisabled = false
    }
    
    func setupData(model: HomeModel) {
        self.model = model
        DispatchQueue.main.async {
            if let avatar = model.avatarImage {
                self.avatarUser.image = UIImage(data: Data(referencing: avatar))
            } else {
                self.avatarUser.image = UIImage(named: "avatar_placeholder")
            }
        }
        starImage.image = model.isStar ? UIImage(named: "star") : UIImage(named: "unstar")
        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        if model.dateCalculate.isEmpty {
            babyAgeLabel.text = "Chưa cập nhật"
            dateBornLabel.text = "Chưa cập nhật"
        } else {
            babyAgeLabel.text = model.dateCalculate
            dateBornLabel.text = model.babyAge
        }
    }
    
    @IBAction func makeHightlight(_ sender: UIButton) {
        if let model = self.model {
            sender.isSelected = model.isStar ? false : true
        }
        starImage.image = sender.isSelected ? UIImage(named: "star") : UIImage(named: "unstar")
        isStar?(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
}
