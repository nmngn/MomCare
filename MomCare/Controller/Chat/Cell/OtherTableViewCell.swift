//
//  OtherTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import UIKit

class OtherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var messLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.traitCollection.userInterfaceStyle == .light {
            timeLabel.textColor = .darkGray
        } else {
            timeLabel.textColor = .lightGray
        }
    }
    
    func setupData(message: Message) {
        messLabel.text = message.body
        timeLabel.text = message.time
        messView.backgroundColor = message.color
    }
}
