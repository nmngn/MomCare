//
//  BaybyAgeTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class BaybyAgeTableViewCell: UITableViewCell {

    @IBOutlet weak var dobLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dobLabel.makeShadow()
        dobLabel.autocorrectionType = .no
        dobLabel.setLeftPaddingPoints(16)
        dobLabel.setRightPaddingPoints(16)
        dobLabel.textColor = .black
        dobLabel.isEnabled = false
        
        ageLabel.makeShadow()
        ageLabel.autocorrectionType = .no
        ageLabel.setLeftPaddingPoints(16)
        ageLabel.setRightPaddingPoints(16)
        ageLabel.textColor = .black
        ageLabel.isEnabled = false
    }

    func setupData(model: DetailModel) {
        dobLabel.text = model.babyAge
        changeStringToDate(dateString: model.babyAge)
    }
    
    func changeStringToDate(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:dateString)!
        
    }
    
    func calculateBabyAge(date: Date) -> String {
        return ""
    }
    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}
