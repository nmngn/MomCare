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
        changeTheme()
        setupWeb()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .default
   }
    
    func setupWeb() {
        self.view.addSubview(webKit)
        let url = URL(string: "https://hongngochospital.vn/che-do-khi-mang-thai/")
        webKit.load(URLRequest(url: url!))
    }
    
    func changeTheme() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 5 {
                self.theme.image = UIImage(named: "time1")
            } else if hour >= 5 && hour < 7 {
                self.theme.image = UIImage(named: "time2")
            } else if hour >= 7 && hour < 9 {
                self.theme.image = UIImage(named: "time3")
            } else if hour >= 9 && hour < 17 {
                self.theme.image = UIImage(named: "time4")
            } else if hour >= 17 && hour < 19 {
                self.theme.image = UIImage(named: "time5")
            } else if hour >= 19 && hour < 23 {
                self.theme.image = UIImage(named: "time2")
            } else {
                self.theme.image = UIImage(named: "time1")
            }
        }
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
