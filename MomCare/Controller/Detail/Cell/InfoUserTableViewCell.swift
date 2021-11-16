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
    @IBOutlet weak var valueTextField: UITextField!
    
    var cellType: DataType?
    var textInput = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
        valueTextField.makeShadow()
        valueTextField.autocorrectionType = .no
        valueTextField.setLeftPaddingPoints(16)
        valueTextField.setRightPaddingPoints(16)
        valueTextField.textColor = .black
    }
    
    func setupData(model: DetailModel) {
        self.cellType = model.dataType
        titleLabel.text = model.title
        valueTextField.text = model.value
    }
    
    func saveInModel() {
        if let cellType = cellType {
            delegate?.sendString(dataType: cellType, text: textInput)
        }
    }
    
}

extension InfoUserTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                self.textInput = text
                self.saveInModel()
            } else {
                delegate?.showAlert()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


