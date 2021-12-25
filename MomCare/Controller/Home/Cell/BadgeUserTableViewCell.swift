//
//  BadgeUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit

class BadgeUserTableViewCell: UITableViewCell {

    @IBOutlet weak var allUserLabel: UILabel!
    @IBOutlet weak var inMonthLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView.makeShadow()
    }
    
    func getNumberPatient(list: [User]) {
        let allPatient = NSMutableAttributedString(string: "\(list.count)", attributes: [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 16, weight: .bold)
        ])
        let textAll = NSMutableAttributedString(string: "Tổng số bệnh nhân hiện có: ", attributes: [
            .foregroundColor :UIColor.black,
            .font : UIFont.systemFont(ofSize: 16, weight: .regular)
        ])
        
        textAll.append(allPatient)
        allUserLabel.attributedText = textAll
        
        let newList = list.filter ({ user in
            let text = updateTime(dateString: user.babyDateBorn)
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
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 16, weight: .bold)
        ])
        let textMonth = NSMutableAttributedString(string: "Số bệnh nhân dự kiến sinh trong tháng này: ", attributes: [
            .foregroundColor :UIColor.black,
            .font : UIFont.systemFont(ofSize: 16, weight: .regular)
        ])
        
        textMonth.append(inMonthPatient)
        inMonthLabel.attributedText = textMonth
    }
    
}
