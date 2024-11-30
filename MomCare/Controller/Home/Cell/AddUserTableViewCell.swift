//
//  AddUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 28/12/2021.
//

import UIKit

class AddUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorItem2
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem2
        }
    }
}
