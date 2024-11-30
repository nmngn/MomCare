//
//  NoteHistoryTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 10/07/2021.
//

import UIKit

class NoteHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = .white
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorTextField
        }
    }
    
    func setupData(model: HistoryModel) {
        titleLabel.text = "Thời gian: \(model.time)"
    }
}
