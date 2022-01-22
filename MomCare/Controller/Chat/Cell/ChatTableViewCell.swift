//
//  ChatTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import UIKit
import FirebaseAuth

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var messLbl: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    func setupData(message: Message) {
        if message.sender == Auth.auth().currentUser?.email {
            leftImage.isHidden = true
            rightImage.isHidden = false
            rightImage.image = UIImage(named: "MeAvatar")
            messView.backgroundColor = UIColor(named: Constant.BrandColors.blue)
        } else {
            leftImage.isHidden = false
            rightImage.isHidden = true
            leftImage.image = UIImage(named: "YouAvatar")
            messView.backgroundColor = UIColor(named: Constant.BrandColors.purple)
        }
        messLbl.text = message.body
    }
}
