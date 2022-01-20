//
//  LogInViewController.swift
//  Spoon Master
//
//  Created by Nam Ngây on 09/01/2021.
//  Copyright © 2021 Nam Ngây. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import LocalAuthentication

// A delay function
func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class LogInViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var theme: UIImageView!
    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ..."]
    var animationContainerView: UIView!
    var autoEmail = UserDefaults.standard.string(forKey: "email")
    var statusPosition = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        configView()
        changeTheme(theme)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if autoEmail != nil {
            emailTextField.text = autoEmail
        }
        setUpAnimation()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func login() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            var number = email
            number.append("@gmail.com")
            Auth.auth().signIn(withEmail: number, password: password) { [weak self] _, error in
                Session.shared.userProfile.userEmail = email
                UserDefaults.standard.set(email, forKey: "email")
                if let error = error {
                    self?.openAlert()
                    print(error)
                } else {
                    self?.animateAfterLogin()
                }
            }
        }
    }
    
    @IBAction func signup(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as?
            SignupViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
        
    func openAlert() {
        let alert = UIAlertController(title: "Lỗi", message: "Số điện thoại hoặc mật khẩu không chính xác", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkTextField() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email.isValidPhone() == true && password.isEmpty == false {
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextField()
        resignFirstResponder()
    }
}

// MARK: - SetupAnimation
extension LogInViewController {
    func configView() {
        navigationController?.isNavigationBarHidden = true
        signUpButton.center.y = view.bounds.height - 50
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 10
        loginButton.layer.masksToBounds = true
        loginButton.setTitle("Đăng nhập", for: .normal)
        
        spinner.center = CGPoint(x: loginButton.bounds.width / 2,
                                 y: loginButton.bounds.height / 2)
        spinner.alpha = 1
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = view.center
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
    }
    
    func setUpUI() {
        heading.center.x -= view.bounds.width
        heading.frame.size.width = view.bounds.width - 88*2
        emailTextField.frame.size.width = view.bounds.width - 50*2
        passwordTextField.frame.size.width = view.bounds.width - 50*2
        emailTextField.frame.size.height = 36
        passwordTextField.frame.size.height = 36
        
        loginButton.frame.size.width = view.bounds.width - 78*2
        emailTextField.center.x -= view.bounds.width
        passwordTextField.center.x -= view.bounds.width
        cloud1.center.x -= view.bounds.width
        cloud2.center.x -= view.bounds.width
        cloud3.center.x -= view.bounds.width
        cloud4.center.x -= view.bounds.width
        
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
        
        loginButton.center.y += 100
        loginButton.alpha = 0
        signUpButton.frame.size.width = view.bounds.width - 100*2
        signUpButton.alpha = 0
        signUpButton.center.y += 50
    }
    
    func setUpAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.signUpButton.center.y -= 50
            self.signUpButton.alpha = 1
        } completion: { _ in}
        
        UIView.animate(withDuration: 1.5) {
            self.heading.center.x += self.view.bounds.width
        }
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.emailTextField.center.x += self.view.bounds.width
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 1, options: []) {
            self.passwordTextField.center.x += self.view.bounds.width
        } completion: { _ in }
        UIView.animate(withDuration: 1, delay: 0.25, options: []) {
            self.cloud1.center.x += self.view.bounds.width
            self.cloud1.alpha = 1
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.5, options: []) {
            self.cloud2.center.x += self.view.bounds.width
            self.cloud2.alpha = 1
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.75, options: []) {
            self.cloud3.center.x += self.view.bounds.width
            self.cloud3.alpha = 1
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.1, options: []) {
            self.cloud4.center.x += self.view.bounds.width
            self.cloud4.alpha = 1
        } completion: { _ in}
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: []) {
            self.loginButton.center.y -= 100
            self.loginButton.alpha = 1
        } completion: { _ in}
    }
    
    func animateAfterLogin() {
        view.endEditing(true)
        loginButton.setTitle("", for: .normal)
        UIView.animate(withDuration: 1.5) {
            self.heading.center.x += self.view.bounds.width
        }
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.emailTextField.center.x += self.view.bounds.width
        } completion: { _ in }
        
        UIView.animate(withDuration: 1.5, delay: 0.75, options: []) {
            self.passwordTextField.center.x += self.view.bounds.width
        } completion: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateInitialViewController()
            UIApplication.shared.windows.first?.rootViewController = homeVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        UIView.animate(withDuration: 1, delay: 0.25, options: []) {
            self.cloud1.center.x += self.view.bounds.width
            self.cloud1.alpha = 0
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.5, options: []) {
            self.cloud2.center.x += self.view.bounds.width
            self.cloud2.alpha = 0
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.75, options: []) {
            self.cloud3.center.x += self.view.bounds.width
            self.cloud3.alpha = 0
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.1, options: []) {
            self.cloud4.center.x += self.view.bounds.width
            self.cloud4.alpha = 0
        } completion: { _ in}
        UIView.animate(withDuration: 1, delay: 0.05, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: []) {
            self.loginButton.center.y += self.view.bounds.height
        } completion: { _ in}
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.signUpButton.center.y += 50
            self.signUpButton.alpha = 0
        } completion: { _ in}
    }
    
}
