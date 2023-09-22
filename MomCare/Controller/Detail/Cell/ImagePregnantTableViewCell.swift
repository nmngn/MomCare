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
    
    var showImage: (() -> ())?
    
    func setupData(model: DetailModel) {
        DispatchQueue.main.async {
            if let image = model.imagePregnant {
                self.imagePregnant.image = image
                let ratio = image.size.width / image.size.height
                let newHeight = self.imagePregnant.frame.width / ratio
                self.constraintHeight.constant = newHeight
                self.subView.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
        showImage?()
    }
}
