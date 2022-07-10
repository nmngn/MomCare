//
//  SettingViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 17/06/2022.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var theme: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cài đặt"
        self.changeTheme(self.theme)
        setupNavigationButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.changeTheme(self.theme)
        self.setupNavigationButton()
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
