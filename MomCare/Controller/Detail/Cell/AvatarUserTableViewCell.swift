//
//  AvatarUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

protocol DetailUserInfo: AnyObject {
    func chooseAvatar()
    func chooseBabyDOB()
    func chooseImage()
    func sendString(dataType: DataType, text: String)
    func showAlert(dataType: DataType)
}

class AvatarUserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var takeButton: UIButton!
    
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        takeButton.makeShadow()
    }

    func setupData(model: DetailModel) {
        if model.avatarImage == nil {
            avatarImage.image = UIImage(named: "avatar_placeholder")
        } else {
            avatarImage.image = model.avatarImage
        }
    }
    
    @IBAction func chooseAvatar(_ sender: UIButton) {
        delegate?.chooseAvatar()
    }
}
