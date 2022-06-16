//
//  MyHistoryNoteTableViewCell.swift
//  MomCare
//
//  Created by Nam Nguyễn on 16/06/2022.
//

import UIKit

class MyHistoryNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageNote: UIImageView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var subView: UIView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme.applyBlurEffect()
    }
    
    func setupData(data: UserInfo) {
        let title1 = NSMutableAttributedString(string: "Nội dung :",
                                             attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        let content1 = NSMutableAttributedString(string: data.titleHisNote,
                                            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        title1.append(content1)
        
        let title2 = NSMutableAttributedString(string: "Thời gian :",
                                             attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        let content2 = NSMutableAttributedString(string: data.timeHisNote,
                                            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        title2.append(content2)
        
        
        titleLabel.attributedText = title1
        timeLabel.attributedText = title2
        if let image = data.imageHisNote {
                self.imageNote.image = image
                let ratio = image.size.width / image.size.height
                let newHeight = self.imageNote.frame.width / ratio
                self.constraintHeight.constant = newHeight
                self.subView.layoutIfNeeded()
            
        }
    }
    
}
