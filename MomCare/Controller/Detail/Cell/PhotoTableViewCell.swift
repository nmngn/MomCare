//
//  PhotoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.traitCollection.userInterfaceStyle == .light {
            title.textColor = .black
        } else {
            title.textColor = UIColor.white.withAlphaComponent(0.8)
        }
    }

    @IBAction func chooseImage(_ sender: UIButton) {
        delegate?.chooseImage()
    }
    
}
