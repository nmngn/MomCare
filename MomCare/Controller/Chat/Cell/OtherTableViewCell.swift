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
    
    func setupData(message: Message) {
        messLabel.text = message.body
        messView.backgroundColor = message.color
    }
}
