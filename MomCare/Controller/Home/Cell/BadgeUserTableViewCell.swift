//
//  BadgeUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class BadgeUserTableViewCell: UITableViewCell {

    @IBOutlet weak var helloTitle: UILabel!
    @IBOutlet weak var goodDayTitle: UILabel!
    @IBOutlet weak var allUserLabel: UILabel!
    @IBOutlet weak var inMonthLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    func getNumberPatient(list: [User]) {
        let text = NSMutableAttributedString(string: Constant.Text.hello, attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.biggerFontSize, weight: .medium)])

        helloTitle.attributedText = text
        
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorBadge
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorBadge
        }
        
        let allPatient = NSMutableAttributedString(string: "\(list.count)", attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .bold)
        ])
        let textAll = NSMutableAttributedString(string: Constant.Text.allPatient, attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .regular)
        ])
        
        textAll.append(allPatient)
        allUserLabel.attributedText = textAll
        
        let newList = list.filter ({ user in
            let text = user.updateTime()
            if !text.isEmpty {
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 1)
                let data = String(text[startIndex...endIndex])
                let result = Int(data) ?? 0 >= 36
                return result
            }
            return false
        })
        
        let inMonthPatient = NSMutableAttributedString(string: "\(newList.count)", attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .bold)
        ])
        let textMonth = NSMutableAttributedString(string: Constant.Text.patientInMonth, attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .regular)
        ])
        
        textMonth.append(inMonthPatient)
        inMonthLabel.attributedText = textMonth
    }
    
}
