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
        avatarUser.image = model.compressNSDataToImage(data: model.avatarImage ?? NSData(), type: .mom)
        userNameLabel.text = model.name
        dayCreateLabel.text = model.dateSave
        babyAgeLabel.text = model.dateCalculate
    }
}
