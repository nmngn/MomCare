//
//  NoteTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextView: UITextView!
    
    var changeHeightCell: (() -> ())?
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextView.makeShadow()
        noteTextView.backgroundColor = .white
        noteTextView.textColor = .black
        noteTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        noteTextView.delegate = self
        noteTextView.autocorrectionType = .no
        noteTextView.isScrollEnabled = false
    }
    
}

extension NoteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changeHeightCell?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            delegate?.sendString(dataType: .note, text: text)
        }
    }
}
