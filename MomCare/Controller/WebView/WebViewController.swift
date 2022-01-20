//
//  WebViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/01/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
        self.title = "Thông tin thêm"
        let myURL = URL(string: "https://eva.vn/mang-thai/che-do-dinh-duong-cho-ba-bau-theo-tung-thang-c383a410980.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
