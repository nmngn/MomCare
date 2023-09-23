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
    var imagePath = ""
    var imageData: UIImage?
    var titleData = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showImage()
        titleLabel.text = "\(titleData) \n\(time)"
    }
    
    func showImage() {
        if let imageData = self.imageData, !self.imagePath.isEmpty {
            DispatchQueue.main.async {
                self.viewImage.image = imageData
                self.viewImage.isUserInteractionEnabled = true
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchImage))
                self.view.addGestureRecognizer(pinchGesture)
            }
        } else {
            if !self.imagePath.isEmpty {
                let _ = loadImageFromDiskWith(fileName: self.imagePath) { [weak self] image in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        strongSelf.viewImage.image = image
                        strongSelf.viewImage.isUserInteractionEnabled = true
                        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(strongSelf.pinchImage))
                        strongSelf.view.addGestureRecognizer(pinchGesture)
                    }
                }
            }
            
            if let imageData = self.imageData {
                DispatchQueue.main.async {
                    self.viewImage.image = imageData
                    self.viewImage.isUserInteractionEnabled = true
                    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchImage))
                    self.view.addGestureRecognizer(pinchGesture)
                }
            }
        }
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
