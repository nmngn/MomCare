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
        dobLabel.delegate = self
        dobLabel.autocorrectionType = .no
        dobLabel.setLeftPaddingPoints(16)
        dobLabel.setRightPaddingPoints(16)
        
        ageLabel.makeShadow()
        ageLabel.autocorrectionType = .no
        ageLabel.setLeftPaddingPoints(16)
        ageLabel.setRightPaddingPoints(16)
    }

    func setupData(model: DetailModel) {
        dobLabel.text = model.babyAge
    }
    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}

extension BaybyAgeTableViewCell: UITextFieldDelegate {
    
}
