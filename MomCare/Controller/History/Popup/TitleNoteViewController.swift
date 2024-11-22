//
//  TitleNoteViewController.swift
//  MomCare
//
//  Created by Nam Nguyễn on 16/06/2022.
//

import UIKit

class TitleNoteViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet private var textView: UITextView!
    
    var titleNote = ""
    var saveNote : ((String) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.autocorrectionType = .no
    }

    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            titleNote = text
        }
    }

    @IBAction func saveAction(_ sender: UIButton) {
        saveNote?(titleNote)
        dismiss(animated: true, completion: nil)
    }
}
