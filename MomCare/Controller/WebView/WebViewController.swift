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
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
        self.title = "Thông tin thêm"
        callUrl()
    }
    
    func callUrl() {
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL ?? URL(fileURLWithPath: ""))
        webView.load(myRequest)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupNavigationButton()
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
