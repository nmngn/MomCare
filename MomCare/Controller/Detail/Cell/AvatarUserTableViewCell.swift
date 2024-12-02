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
        if model.avatarImage == nil && model.avatarImagePath.isEmpty {
            avatarImage.image = UIImage(named: Constant.Text.avatarPlaceholder)
        } else if model.avatarImage != nil && !model.avatarImagePath.isEmpty {
            DispatchQueue.main.async {
                self.avatarImage.image = model.avatarImage
            }
        } else {
            if !model.avatarImagePath.isEmpty {
                let _ = loadImageFromDiskWith(fileName: model.avatarImagePath) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.avatarImage.image = image
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.avatarImage.image = model.avatarImage
            }
        }
    }
    
    @IBAction func chooseAvatar(_ sender: UIButton) {
        delegate?.chooseAvatar()
    }
}
