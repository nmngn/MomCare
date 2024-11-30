//
//  NoteTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    var changeHeightCell: (() -> ())?
    weak var delegate: DetailUserInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextView.makeShadow()
        noteTextView.backgroundColor = .white
        noteTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        noteTextView.delegate = self
        noteTextView.autocorrectionType = .no
        noteTextView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.traitCollection.userInterfaceStyle == .light {
            noteTextView.backgroundColor = .white
        } else {
            noteTextView.backgroundColor = Constant.BrandColors.darkColorTextField
        }
    }
    
    func setupData(model: DetailModel) {
        noteTextView.text = model.note
    }
}

extension NoteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changeHeightCell?()
        if let text = textView.text {
            delegate?.sendString(dataType: .note, text: text)
        }

    }
}
