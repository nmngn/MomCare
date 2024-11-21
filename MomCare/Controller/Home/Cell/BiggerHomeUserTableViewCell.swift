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
    @IBOutlet weak var widthNotiConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonStar: UIButton!
    
    var isStar: ((Bool) -> Void)?
    var showNotificationTime: ((String) -> Void)?
    var model = HomeModel(type: .infoUser)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
        subView.makeBorderColor()
    }
    
    func setupData(model: HomeModel) {
        self.model = model
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
        
        if !model.avatarImage.isEmpty {
            let _ = loadImageFromDiskWith(fileName: model.avatarImage) { [weak self] image in
                DispatchQueue.main.async {
                    self?.avatarUser.image = image
                }
            }
        } else {
            self.avatarUser.image = UIImage(named: Constant.Text.avatarPlaceholder)
        }
        
        widthNotiConstraint.constant = model.notificationTime.isEmpty ? 0: 36
        
        buttonStar.setImage(model.isStar
                            ? UIImage(systemName: "star.fill")?.toHierachicalImage()
                            : UIImage(systemName: "star")?.toHierachicalImage(),
                            for: .normal)
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
        sender.isSelected = model.isStar ? false : true
        buttonStar.setImage(sender.isSelected
                             ? UIImage(systemName: "star.fill")?.toHierachicalImage()
                             : UIImage(systemName: "star")?.toHierachicalImage(),
                             for: .normal)
        isStar?(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func setNotificationAction(_ sender: UIButton) {
        self.showNotificationTime?(model.notificationTime)
    }
}
