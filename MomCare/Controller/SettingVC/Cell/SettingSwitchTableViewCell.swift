//
//  SettingSwitchTableViewCell.swift
//  MomCare
//
//  Created by NamNT1 on 27/09/2023.
//

import UIKit

class SettingSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    var switchChanged: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupData(model: SettingModel) {
        self.titleLabel.text = model.title
        self.switchView.isOn = model.isEditting
    }
    
    @IBAction func switchChangeValue(_ sender: UISwitch) {
        self.switchChanged?(sender.isOn)
    }
}
