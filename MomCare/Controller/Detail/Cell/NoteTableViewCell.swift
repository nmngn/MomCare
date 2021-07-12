//
//  NoteTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextField: UITextField!
    
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextField.makeShadow()
        noteTextField.delegate = self
    }
}

extension NoteTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                delegate?.saveNote(text: text)
            }
        }
    }
}
