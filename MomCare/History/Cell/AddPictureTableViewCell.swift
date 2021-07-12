//
//  AddPictureTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit

class AddPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
}
