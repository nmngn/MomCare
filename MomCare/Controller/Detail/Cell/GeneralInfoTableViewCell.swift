//
//  GeneralInfoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var generalTitle: UILabel!
    @IBOutlet weak var dayCreate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupData(nil)
    }
            
    func setupData(_ model: DetailModel?) {
        if model?.dateSave == "" {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constant.Text.dateFormatDetail
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            let text = NSMutableAttributedString(string: Constant.Text.dateCreated,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            let day = NSMutableAttributedString(string: "\(dateString)",
                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            text.append(day)
            dayCreate.attributedText = text
        } else {
            let text = NSMutableAttributedString(string: Constant.Text.dateCreated,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            let day = NSMutableAttributedString(string: "\(model?.dateSave ?? Constant.Text.notUpdated)",
                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            text.append(day)
            dayCreate.attributedText = text
        }
    }
    
}
