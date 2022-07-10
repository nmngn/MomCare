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
        notiImage.image = UIImage(systemName: "bell")?.toHierachicalImage()
        theme.applyBlurEffect()
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        dismissView.addGestureRecognizer(tapGestureReconizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !notiModel.isEmpty {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.notiImage.image = UIImage(systemName: "bell.badge")?.toHierachicalImage()
            }, completion: nil)
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openNoti(_ sender: UIButton) {
        let vc = NotificationViewController.init(nibName: "NotificationViewController", bundle: nil)
        vc.notiModel = self.notiModel
        dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
    
    @IBAction func openProfile(_ sender: UIButton) {
        let vc = WebViewController.init(nibName: "WebViewController", bundle: nil)
        dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
        
    @IBAction func logOut(_ sender: UIButton) {
        let vc = SettingViewController.init(nibName: "SettingViewController", bundle: nil)
        dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
}
