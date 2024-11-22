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
        dobLabel.isEnabled = false
        
        ageLabel.makeShadow()
        ageLabel.autocorrectionType = .no
        ageLabel.setLeftPaddingPoints(16)
        ageLabel.setRightPaddingPoints(16)
        ageLabel.isEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            dobLabel.backgroundColor = .white
            ageLabel.backgroundColor = .white
        } else {
            dobLabel.backgroundColor = Constant.BrandColors.darkColorItem
            ageLabel.backgroundColor = Constant.BrandColors.darkColorItem
        }
    }
    
    func setupData(model: DetailModel) {
        self.cellType = model.dataType
        dobLabel.text = model.babyAge
        ageLabel.text = model.dateCalculate
        delegate?.sendString(dataType: .babyAge, text: model.babyAge)
    }

    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}
