//
//  CurrentTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 27/02/2022.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {

    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var messLabel: UILabel!
            
    func setupData(message: Message) {
        messLabel.text = message.body
        messView.backgroundColor = message.color
    }
}
