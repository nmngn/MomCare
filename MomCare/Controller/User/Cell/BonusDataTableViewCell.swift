//
//  BonusDataTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 29/01/2022.
//

import UIKit

class BonusDataTableViewCell: UITableViewCell {

    @IBOutlet weak var textDataLabel: UILabel!
    @IBOutlet weak var theme: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        theme.applyBlurEffect()
    }

    func setupData(text: String) {
        textDataLabel.text = text
    }
}
