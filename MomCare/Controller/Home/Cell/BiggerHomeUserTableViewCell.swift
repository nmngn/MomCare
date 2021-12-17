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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
        subView.makeBorderColor()
    }
    
    func setupData(model: HomeModel) {
        DispatchQueue.main.async {
            self.avatarUser.image = model.loadImageFromDiskWith(fileName: model.numberPhone) ?? UIImage(named: "avatar_placeholder")
        }
        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        babyAgeLabel.text = model.dateCalculate
    }
}
