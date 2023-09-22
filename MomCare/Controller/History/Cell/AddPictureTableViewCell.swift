//
//  AddPictureTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit

class AddPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    func setupData(model: HistoryModel) {
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = .white
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorItem
        }
    }
}
