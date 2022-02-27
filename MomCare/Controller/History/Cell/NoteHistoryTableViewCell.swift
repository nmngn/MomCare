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
    
    func setupData(model: HistoryModel) {
        titleLabel.text = "Thời gian: \(model.title)"
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = .white
        } else {
            subView.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        }
    }

}
