//
//  ImagePregnantTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 05/10/2021.
//

import UIKit

class ImagePregnantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePregnant: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    func setupData(model: DetailModel) {
        if let image = model.imagePregnant {
            imagePregnant.image = image
            let ratio = image.size.width / image.size.height
            let newHeight = imagePregnant.frame.width / ratio
            constraintHeight.constant = newHeight
            subView.layoutIfNeeded()
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
    }
}
