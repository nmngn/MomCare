//
//  PopupUserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 11/03/2022.
//

import UIKit
import FirebaseAuth

class PopupUserViewController: UIViewController {

    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var theme: UIImageView!
    
    var navigation = UINavigationController()
    var detailUser = DetailModel()
    var adminData : Admin?
    var isUserChat = false
    override func viewDidLoad() {
        super.viewDidLoad()
        theme.applyBlurEffect()
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        dismissView.addGestureRecognizer(tapGestureReconizer)
    }
        
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openChat(_ sender: UIButton) {
        let vc = ChatViewController.init(nibName: "ChatViewController", bundle: nil)
        vc.detailUser = detailUser
        vc.adminData = adminData
        vc.isUserChat = true
        dismissVC()
        self.navigation.pushViewController(vc, animated: true)
    }
    
    func logOut() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.signOut()
        }
        let noAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "LogInView", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print(signOutError)
            popupErrorSignout()
        }
    }
    
    func popupErrorSignout() {
        let alert = UIAlertController(title: "Lỗi", message: "Đăng xuất lỗi", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openMore(_ sender: UIButton) {
        let vc = WebViewController.init(nibName: "WebViewController", bundle: nil)
        dismissVC()
        navigation.pushViewController(vc, animated: true)
    }
        
    @IBAction func logOut(_ sender: UIButton) {
        logOut()
    }
}
