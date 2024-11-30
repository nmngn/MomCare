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
    var userPhone = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            valueTextField.backgroundColor = .white
            callButton.backgroundColor = .white
        } else {
            valueTextField.backgroundColor = Constant.BrandColors.darkColorTextField
            callButton.backgroundColor = Constant.BrandColors.darkColorTextField
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        valueTextField.makeShadow()
        valueTextField.autocorrectionType = .no
        valueTextField.setLeftPaddingPoints(16)
        valueTextField.setRightPaddingPoints(16)
    }
    
    func setupData(model: DetailModel) {
        valueTextField.isEnabled = model.isActive
        self.cellType = model.dataType
        titleLabel.text = model.title
        valueTextField.text = model.value
        userPhone = model.numberPhone
        if !model.isCall {
            valueTextField.keyboardType = .default
            widthCallButtonConstraint.constant = 0
            callButton.isEnabled = false
            callButton.isHidden = true
        } else {
            valueTextField.keyboardType = .numberPad
            if model.numberPhone.isEmpty {
                widthCallButtonConstraint.constant = 0
                callButton.isEnabled = false
                callButton.isHidden = true
            } else {
                widthCallButtonConstraint.constant = 40
                callButton.isEnabled = true
                callButton.isHidden = false
            }
        }
    }
    
    func saveInModel(_ text: String) {
        if let cellType = cellType {
            delegate?.sendString(dataType: cellType, text: text)
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                self.saveInModel(text)
            }
        }
    }
    
    @IBAction func callNumber(_ sender: UIButton) {
        if let url = URL(string: "telprompt://\(self.userPhone)"),
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
            if cellType == .numberPhone {
                self.saveInModel(text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


