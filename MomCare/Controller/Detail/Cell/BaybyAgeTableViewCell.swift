//
//  BaybyAgeTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class BaybyAgeTableViewCell: UITableViewCell {

    @IBOutlet weak var dobTitle: UILabel!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var dobLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    
    weak var delegate: DetailUserInfo?
    var cellType: DataType?
    
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
        self.cellType = model.dataType
        dobLabel.text = model.babyAge
        ageLabel.text = model.dateCalculate
        
        dobTitle.textColor = model.contrastColor
        dobLabel.textColor = model.contrastColor
        ageLabel.textColor = model.contrastColor
        ageTitle.textColor = model.contrastColor
        if model.contrastColor == .black {
            dobLabel.backgroundColor = .white
            ageLabel.backgroundColor = .white
        } else {
            dobLabel.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
            ageLabel.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        }

        delegate?.sendString(dataType: .babyAge, text: model.babyAge)
    }

    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}
