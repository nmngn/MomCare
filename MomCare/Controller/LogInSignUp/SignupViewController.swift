//
//  SignupViewController.swift
//  Spoon Master
//
//  Created by Nam Ngây on 09/01/2021.
//  Copyright © 2021 Nam Ngây. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwLabel: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ..."]
    var animationContainerView: UIView!
    var statusPosition = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPwLabel.delegate = self
        signUpButton.isEnabled = false
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
        setUpAnimation()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signup() {
        if let email = emailTextField.text, let password = passwordTextField.text,
           let confirmPw = confirmPwLabel.text {
            if confirmPw == password {
                var number = email
                number.append("@gmail.com")
                Auth.auth().createUser(withEmail: number, password: password) { (authDataResult, error) in
                    if let error = error {
                        print("Create error: \(error.localizedDescription)")
                        if let error = error as NSError? {
                            print("Error code: \(error.code)")
                            switch error.code {
                            case 17007:
                                self.openAlert("Số điện thoại đã bị trùng bởi người dùng khác")
                            case 17026:
                                self.openAlert("Mật khẩu phải dài hơn 6 kí tự")
                            default:
                                break
                            }
                        }
                    } else {
                        print("Profile \(authDataResult?.additionalUserInfo?.profile ?? [:])")
                        Session.shared.userProfile.userNumberPhone = email
                        UserDefaults.standard.set(email, forKey: "sdt")
                        self.animateAfterSignUp()
                    }
                }
            } else {
                openAlert("Mật khẩu không trùng khớp")
            }
        }
        
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LogInView", bundle: nil)
        if let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as?
            LogInViewController {
            navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    func openAlert(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkTextField() {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirm = confirmPwLabel.text {
            if email.isValidPhone() == true && !password.isEmpty && !confirm.isEmpty {
                signUpButton.isEnabled = true
            } else {
                signUpButton.isEnabled = false
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
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
extension SignupViewController {
    func configView() {
        navigationController?.isNavigationBarHidden = true
        //set up the UI
        logInButton.center.y = view.bounds.height - 50
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 10
        signUpButton.layer.masksToBounds = true
        signUpButton.setTitle("Đăng kí", for: .normal)
        
        spinner.center = CGPoint(x: signUpButton.bounds.width / 2,
                                 y: signUpButton.bounds.height / 2)
        spinner.alpha = 1
        signUpButton.addSubview(spinner)
        
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
        emailTextField.center.x -= view.bounds.width
        passwordTextField.center.x -= view.bounds.width
        confirmPwLabel.center.x -= view.bounds.width
        heading.frame.size.width = view.bounds.width - 88*2
        emailTextField.frame.size.width = view.bounds.width - 50*2
        passwordTextField.frame.size.width = view.bounds.width - 50*2
        confirmPwLabel.frame.size.width = view.bounds.width - 50*2
        signUpButton.frame.size.width = view.bounds.width - 78*2
        confirmPwLabel.frame.size.height = 36
        emailTextField.frame.size.height = 36
        passwordTextField.frame.size.height = 36
        
        cloud1.center.x -= view.bounds.width
        cloud2.center.x -= view.bounds.width
        cloud3.center.x -= view.bounds.width
        cloud4.center.x -= view.bounds.width
        
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
        
        signUpButton.center.y += 100
        signUpButton.alpha = 0
        logInButton.frame.size.width = view.bounds.width - 100*2
        logInButton.alpha = 0
        logInButton.center.y += 50
    }
    
    func setUpAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.logInButton.center.y -= 50
            self.logInButton.alpha = 1
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
        UIView.animate(withDuration: 1.25, delay: 0.75, options: []) {
            self.confirmPwLabel.center.x += self.view.bounds.width
        }
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
            self.signUpButton.center.y -= 100
            self.signUpButton.alpha = 1
        } completion: { _ in}

    }
    
    func animateAfterSignUp() {
        view.endEditing(true)
        signUpButton.setTitle("", for: .normal)
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
    
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [], animations: {
            self.confirmPwLabel.center.x += self.view.bounds.width
        }, completion: nil)
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
            self.signUpButton.center.y += self.view.bounds.height
        } completion: { _ in}
        UIView.animate(withDuration: 1.5, delay: 0.5, options: []) {
            self.logInButton.center.y += 50
            self.logInButton.alpha = 0
        } completion: { _ in}
    }
}
