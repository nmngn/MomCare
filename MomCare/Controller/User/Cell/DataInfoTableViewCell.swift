//
//  DataInfoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 23/01/2022.
//

import UIKit

class DataInfoTableViewCell: UITableViewCell {
    
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
