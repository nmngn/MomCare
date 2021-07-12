//
//  InfoUserTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class InfoUserTableViewCell: UITableViewCell {
    
    weak var delegate: DetailUserInfo?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var valueTextField: UITextField!
    
    var typeCell: DataType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
        valueTextField.makeShadow()
        valueTextField.setLeftPaddingPoints(10)
        valueTextField.setRightPaddingPoints(10)
    }
    
    func setupData(model: DetailModel) {
        self.typeCell = model.dataType
        titleLabel.text = model.title
        valueTextField.text = model.value
        calendarButton.isHidden = !model.showCalendar
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        delegate?.chooseDOB()
    }
    
}

extension InfoUserTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                if let type = self.typeCell {
                    delegate?.sendString(dataType: type, text: text)
                }
            } else {
                delegate?.showAlert()
            }
        }
    }
}
