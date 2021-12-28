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
        title.textColor = model.contrastColor
        if model.contrastColor == .black {
            subView.backgroundColor = .white
        } else {
            subView.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        }
    }
}
