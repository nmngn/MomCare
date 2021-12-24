//
//  ShowImageDetailViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 24/12/2021.
//

import UIKit

class ShowImageDetailViewController: UIViewController {

    @IBOutlet weak var viewImage: UIImageView!
    var imageData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showImage()
    }
    
    func showImage() {
        if let data = self.imageData {
            if let image = UIImage(data: Data(referencing: data)) {
                viewImage.image = image
                viewImage.isUserInteractionEnabled = true
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage))
                view.addGestureRecognizer(pinchGesture)
            }
        }
    }
    
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) ?? CGAffineTransform()
        sender.scale = 1.0
    }
}
