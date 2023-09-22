//
//  SmallOptionViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 19/01/2022.
//

import UIKit

class SmallOptionViewController: UIViewController {
    
    @IBOutlet weak var notiImage: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var theme: UIImageView!
    
    var notiModel = [NotificationModel]()
    var navigation = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notiImage.image = UIImage(systemName: Constant.Text.bell)?.toHierachicalImage()
        self.theme.applyBlurEffect()
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        self.dismissView.addGestureRecognizer(tapGestureReconizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.notiModel.isEmpty {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.notiImage.image = UIImage(systemName: Constant.Text.badgeBell)?.toHierachicalImage()
            }, completion: nil)
        }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func openNoti(_ sender: UIButton) {
        let vc = NotificationViewController.init(nibName: NotificationViewController.className, bundle: nil)
        vc.notiModel = self.notiModel
        self.dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
    
    @IBAction func openWebview(_ sender: UIButton) {
        let vc = WebViewController.init(nibName: WebViewController.className, bundle: nil)
        self.dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
        
    @IBAction func settingAction(_ sender: UIButton) {
        let vc = SettingViewController.init(nibName: SettingViewController.className, bundle: nil)
        self.dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
}
