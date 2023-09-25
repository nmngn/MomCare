//
//  ShowImageDetailViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 24/12/2021.
//

import UIKit

class ShowImageDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var imagePath = ""
    var imageData: UIImage?
    var titleData = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        viewImage.isUserInteractionEnabled = true
        viewImage.addGestureRecognizer(panGesture)
        
        self.viewImage.isUserInteractionEnabled = true
        
        self.showImage()
        titleLabel.text = "\(titleData) \n\(time)"
    }
    
    func showImage() {
        if let imageData = self.imageData, !self.imagePath.isEmpty {
            DispatchQueue.main.async {
                self.viewImage.image = imageData
            }
        } else {
            if !self.imagePath.isEmpty {
                let _ = loadImageFromDiskWith(fileName: self.imagePath) { [weak self] image in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        strongSelf.viewImage.image = image
                    }
                }
            }
            
            if let imageData = self.imageData {
                DispatchQueue.main.async {
                    self.viewImage.image = imageData
                }
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewImage
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let center = gestureRecognizer.location(in: viewImage)
            let zoomRect = CGRect(x: center.x, y: center.y, width: 1, height: 1)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            viewImage.center = CGPoint(x: viewImage.center.x + translation.x, y: viewImage.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
}
