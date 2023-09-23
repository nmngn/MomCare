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
        if model.imagePregnant != nil && !model.imagePregnantPath.isEmpty {
            if let image = model.imagePregnant {
                DispatchQueue.main.async {
                    self.imagePregnant.image = image
                    let ratio = image.size.width / image.size.height
                    let newHeight = self.imagePregnant.frame.width / ratio
                    self.constraintHeight.constant = newHeight
                    self.subView.layoutIfNeeded()
                }
            }
        } else {
            if !model.imagePregnantPath.isEmpty {
                let _ = loadImageFromDiskWith(fileName: model.imagePregnantPath) { [weak self] image in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        strongSelf.imagePregnant.image = image
                        let ratio = image.size.width / image.size.height
                        let newHeight = strongSelf.imagePregnant.frame.width / ratio
                        strongSelf.constraintHeight.constant = newHeight
                        strongSelf.subView.layoutIfNeeded()
                        
                    }
                }
            }
            
            if let image = model.imagePregnant {
                DispatchQueue.main.async {
                    self.imagePregnant.image = image
                    let ratio = image.size.width / image.size.height
                    let newHeight = self.imagePregnant.frame.width / ratio
                    self.constraintHeight.constant = newHeight
                    self.subView.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
        showImage?()
    }
}
