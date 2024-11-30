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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            subView.backgroundColor = Constant.BrandColors.lightColorBadge
        } else {
            subView.backgroundColor = Constant.BrandColors.darkColorBadge
        }
    }
    
    func getNumberPatient(list: [User]) {
        let text = NSMutableAttributedString(string: Constant.Text.hello, attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.biggerFontSize, weight: .medium)])

        helloTitle.attributedText = text
        
        let allPatient = NSMutableAttributedString(string: "\(list.count)", attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .bold)
        ])
        let textAll = NSMutableAttributedString(string: Constant.Text.allPatient, attributes: [
            .font : UIFont.systemFont(ofSize: Constant.Size.normalFontSize, weight: .regular)
        ])
        
        textAll.append(allPatient)
        allUserLabel.attributedText = textAll
        
        let newList = list.filter ({ user in
            if !user.babyDateBorn.isEmpty {
                let startIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 3)
                let endIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 4)
                let data = String(user.babyDateBorn[startIndex...endIndex])
                let result = Int(data) ?? 0 == Calendar.current.component(.month, from: Date())
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
