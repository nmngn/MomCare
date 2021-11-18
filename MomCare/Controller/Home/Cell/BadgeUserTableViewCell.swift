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
        
        let inMonthPatient = NSMutableAttributedString(string: "\(0)", attributes: [
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
