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
        var contrastColor = UIColor()
        if self.traitCollection.userInterfaceStyle == .light {
            generalTitle.textColor = .black
            contrastColor = .black
        } else {
            generalTitle.textColor = UIColor.white.withAlphaComponent(0.8)
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        if model?.dateSave == "" {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            let text = NSMutableAttributedString(string: "Ngày đăng kí:  ",
                                                 attributes: [.foregroundColor: contrastColor,
                                                              .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            let day = NSMutableAttributedString(string: "\(dateString)",
                                                attributes: [.foregroundColor: contrastColor,
                                                             .font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            text.append(day)
            dayCreate.attributedText = text
        } else {
            let text = NSMutableAttributedString(string: "Ngày đăng kí:  ",
                                                 attributes: [.foregroundColor: contrastColor,
                                                              .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            let day = NSMutableAttributedString(string: "\(model?.dateSave ?? "Chưa cập nhật")",
                                                attributes: [.foregroundColor: contrastColor,
                                                             .font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            text.append(day)
            dayCreate.attributedText = text
        }
    }
    
}
