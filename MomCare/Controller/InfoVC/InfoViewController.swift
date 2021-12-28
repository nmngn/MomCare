//
//  InfoViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 28/12/2021.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webKit: WKWebView!
    @IBOutlet weak var theme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin thêm"
        setupNavigationButton()
        setupWeb()
    }

    func setupWeb() {
        self.view.addSubview(webKit)
        let url = URL(string: "https://hongngochospital.vn/che-do-khi-mang-thai/")
        webKit.load(URLRequest(url: url!))
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
