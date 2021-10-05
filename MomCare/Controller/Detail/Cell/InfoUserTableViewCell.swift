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
    
    var typeCell: DataType?
    var model: DetailModel?
    
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
        self.model = model
        self.typeCell = model.dataType
        titleLabel.text = model.title
        valueTextField.text = model.value
    }
    
}

extension InfoUserTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                if let type = self.typeCell {
                    switch typeCell {
                    case .name:
                        model?.name = text
                    case .address:
                        model?.address = text
                    case .dob:
                        model?.dob = text
                    case .numberPhone:
                        model?.numberPhone = text
                    case .height:
                        model?.height = text
                    case .babyAge:
                        model?.babyAge = text
                    case .dateCalculate:
                        model?.dateCalculate = text
                    case .note:
                        model?.note = text
                    default:
                        break
                    }
                    delegate?.sendString(dataType: type, text: text)
                }
            } else {
                delegate?.showAlert()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
