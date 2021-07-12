//
//  BadgeUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class BadgeUserTableViewCell: UITableViewCell {

    @IBOutlet weak var allUserLabel: UILabel!
    @IBOutlet weak var inMonthLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
}
