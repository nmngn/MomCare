//
//  ShowImageDetailViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 24/12/2021.
//

import UIKit

class ShowImageDetailViewController: UIViewController {

    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var imageData = ""
    var imageInDetail: UIImage?
    var inDetail = false
    var titleData = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !inDetail {
            showImage()
        } else {
            showImageInDetail()
        }
        titleLabel.text = "\(titleData) \n\(time)"
    }
    
    func showImage() {
        if self.imageData != "" {
            if let image = loadImageFromDiskWith(fileName: imageData) {
                viewImage.image = image
                viewImage.isUserInteractionEnabled = true
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage))
                view.addGestureRecognizer(pinchGesture)
            }
        }
    }
    
    func showImageInDetail() {
        viewImage.image = imageInDetail
        viewImage.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage))
        view.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
