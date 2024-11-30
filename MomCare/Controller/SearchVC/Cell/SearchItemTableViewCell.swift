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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
    }
    
    func setupData(model: User) {
        DispatchQueue.main.async {
            if !model.avatar.isEmpty {
                let _ = loadImageFromDiskWith(fileName: model.avatar) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.avatarUser.image = image
                    }
                }
            } else {
                self.avatarUser.image = UIImage(named: Constant.Text.avatarPlaceholder)
            }
        }

        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        if updateTime(dateString: model.babyDateBorn).isEmpty {
            babyAgeLabel.text = Constant.Text.notUpdated
            dateBornLabel.text = Constant.Text.notUpdated
        } else {
            babyAgeLabel.text = updateTime(dateString: model.babyDateBorn)
            dateBornLabel.text = model.babyDateBorn
        }
    }
}
