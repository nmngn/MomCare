//
//  PhotoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    weak var delegate: DetailUserInfo?

    @IBAction func chooseImage(_ sender: UIButton) {
        delegate?.chooseImage()
    }
    
}
