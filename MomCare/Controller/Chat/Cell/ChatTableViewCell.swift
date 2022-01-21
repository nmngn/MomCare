//
//  ChatTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import UIKit
import FirebaseAuth

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var MessView: UIView!
    @IBOutlet weak var MessLbl: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    func setupData(message: Message) {
        if message.sender == Auth.auth().currentUser?.email {
            leftImage.isHidden = true
            rightImage.isHidden = false
            rightImage.image = UIImage(named: "MeAvatar")
            MessLbl.backgroundColor = UIColor(named: Constant.BrandColors.blue)
        } else {
            leftImage.isHidden = false
            rightImage.isHidden = true
            leftImage.image = UIImage(named: "YouAvatar")
            MessLbl.backgroundColor = UIColor(named: Constant.BrandColors.purple)
        }
        MessLbl.text = message.body
    }
}
