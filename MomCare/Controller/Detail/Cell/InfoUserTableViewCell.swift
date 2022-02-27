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
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var widthCallButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthMessageButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacingButton: NSLayoutConstraint!
    
    var cellType: DataType?
    var textInput = ""
    var isAdmin = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self
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
        textInput = model.numberPhone
        if !model.isCall {
            widthCallButtonConstraint.constant = 0
            callButton.isEnabled = false
            callButton.isHidden = true
            widthMessageButtonConstraint.constant = 0
            messageButton.isHidden = true
            messageButton.isEnabled = false
            spacingButton.constant = 4
        }
        if self.traitCollection.userInterfaceStyle == .light {
            valueTextField.backgroundColor = .white
            callButton.backgroundColor = .white
            messageButton.backgroundColor = .white
        } else {
            valueTextField.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
            callButton.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
            messageButton.backgroundColor = UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        }
    }
    
    func saveInModel() {
        if let cellType = cellType {
            delegate?.sendString(dataType: cellType, text: textInput)
        }
    }
    
    @IBAction func callNumber(_ sender: UIButton) {
        if let url = URL(string: "telprompt://\(self.textInput)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func letChat(_ sender: UIButton) {
        delegate?.letChat()
    }
}

extension InfoUserTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                self.textInput = text
                self.saveInModel()
            } else {
                if !isAdmin {
                    if let cellType = cellType {
                        delegate?.showAlert(dataType: cellType)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


