//
//  AdminInfoTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 29/01/2022.
//

import UIKit

class AdminInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberPhoneLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var theme: UIImageView!
    
    var number = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme.applyBlurEffect()
    }

    func setupData(data: Admin) {
        number = data.numberPhone
        nameLabel.text = data.name
        addressLabel.text = data.address
        numberPhoneLabel.text = data.numberPhone
        avatarImage.image = loadImageFromDiskWith(fileName: data.image)
        heightLabel.text = data.email
    }
    
    @IBAction func callAdmin(_ sender: UIButton) {
        if let url = URL(string: "telprompt://\(self.number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
