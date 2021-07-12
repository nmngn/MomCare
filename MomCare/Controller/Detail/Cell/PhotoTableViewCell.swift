//
//  PhotoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if imgView.image == nil {
            imageHeight.constant = 0
        }
    }

    @IBAction func chooseImage(_ sender: UIButton) {
        delegate?.chooseImage()
    }
    
}
