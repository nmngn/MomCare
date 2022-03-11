//
//  IlluImageTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 10/03/2022.
//

import UIKit

class IlluImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var illuImage: UIImageView!
    
    func setupImage(image: UIImage) {
        illuImage.image = image
    }
    
}
