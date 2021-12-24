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
    
    func setupData(text: String) {
        titleLabel.text = "Thời gian: \(text)"
    }

}
