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
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
        
        DispatchQueue.main.async {
            if !model.avatarImage.isEmpty {
                self.avatarUser.image = loadImageFromDiskWith(fileName: model.avatarImage)
            } else {
                self.avatarUser.image = UIImage(named: Constant.Text.avatarPlaceholder)
            }
        }
        starImage.image = model.isStar ? UIImage(named: Constant.Text.star) : UIImage(named: Constant.Text.unStar)
        userNameLabel.text = model.name
        
        dayCreateLabel.text = model.dateSave
        
        if model.dateCalculate.isEmpty {
            babyAgeLabel.text = Constant.Text.notUpdated
            dateBornLabel.text = Constant.Text.notUpdated
        } else {
            babyAgeLabel.text = model.dateCalculate
            dateBornLabel.text = model.babyAge
        }
    }
    
    @IBAction func makeHightlight(_ sender: UIButton) {
        if let model = self.model {
            sender.isSelected = model.isStar ? false : true
        }
        starImage.image = sender.isSelected ? UIImage(named: Constant.Text.star) : UIImage(named: Constant.Text.unStar)
        isStar?(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
}
