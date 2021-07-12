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
        ageLabel.makeShadow()
    }

    func setupData(model: DetailModel) {
        
    }
    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}
