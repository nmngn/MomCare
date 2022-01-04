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
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var widthCallButtonConstraint: NSLayoutConstraint!
    
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
        if model.dataType == .numberPhone {
            valueTextField.keyboardType = .numberPad
        }
        self.cellType = model.dataType
        titleLabel.text = model.title
        valueTextField.text = model.value
        titleLabel.textColor = model.contrastColor
        valueTextField.textColor = model.contrastColor
        if !model.isCall {
            widthCallButtonConstraint.constant = 4
            callButton.isEnabled = false
            callButton.isHidden = true
        }
        if model.contrastColor == .black {
            valueTextField.backgroundColor = .white
            callButton.backgroundColor = .white
        } else {
            valueTextField.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
            callButton.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        }
    }
    
    func saveInModel() {
        if let cellType = cellType {
            delegate?.sendString(dataType: cellType, text: textInput)
        }
    }
    
    @IBAction func callNumber(_ sender: UIButton) {
        if let url = URL(string: "tel://\(self.textInput)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
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
                if let cellType = cellType {
                    delegate?.showAlert(dataType: cellType)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


