//
//  ChatViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var theme : UIImageView!
    
    var messages : [Message] = []
    var detailUser = DetailModel()
    var adminData: Admin?
    var isUserChat = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trò chuyện"
        configView()
        loadMessage()
        changeTheme(theme)
        theme.applyBlurEffect()
        setupNavigationButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
        theme.applyBlurEffect()
        setupNavigationButton()
        tableView.reloadData()
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "phone.arrow.up.right")?.toHierachicalImage()
                                        , style: .plain, target: self, action:
                                        #selector(call))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func call() {
        var numberPhone = ""
        if isUserChat {
            numberPhone = self.adminData?.numberPhone ?? ""
        } else {
            numberPhone = self.detailUser.numberPhone
        }
        if let url = URL(string: "telprompt://\(numberPhone)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            switch UIDevice.current.screenType {
            case .iPhones_4_4S, .iPhones_5_5s_5c_SE, .iPhones_6Plus_6sPlus_7Plus_8Plus, .iPhones_6_6s_7_8_SE2:
                self.bottomHeightConstraint.constant = keyboardHeight + 8
            default :
                self.bottomHeightConstraint.constant = keyboardHeight - 16
            }
            scrollToBottom()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomHeightConstraint.constant = 16
        scrollToBottom()
        self.view.layoutIfNeeded()
    }
    
    func configView() {
        messageTextField.delegate = self
        messageTextField.autocorrectionType = .no
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: OtherTableViewCell.self)
            $0.registerNibCellFor(type: CurrentTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
            $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if !self.messages.isEmpty {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    func loadMessage() {
        let messageDB = Database.database().reference().child("messages")

        messageDB.observe(.childAdded) { [weak self] (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let received = snapshotValue["received"] ?? ""
            let text = snapshotValue["body"] ?? ""
            let sender = snapshotValue["sender"] ?? ""
            let time = snapshotValue["time"] ?? ""
            
            print(text, "sender : \(sender)","receiver: \(received)")
            if self?.isUserChat == true {
                if sender == Auth.auth().currentUser?.email || received == Auth.auth().currentUser?.email {
                    var message = Message()
                    message.body = text
                    message.sender = sender
                    message.received = received
                    message.time = time
                    if message.sender == Auth.auth().currentUser?.email {
                        message.type = .current
                        message.textAlignment = .right
                        message.color = UIColor(named: Constant.BrandColors.blue)
                    } else {
                        message.type = .other
                        message.textAlignment = .left
                        message.color = UIColor(named: Constant.BrandColors.purple)
                    }
                    self?.messages.append(message)
                }
            } else {
                if received == self?.detailUser.email() || sender == self?.detailUser.email() {
                    var message = Message()
                    message.body = text
                    message.sender = sender
                    message.received = received
                    message.time = time
                    if message.sender == Auth.auth().currentUser?.email {
                        message.type = .current
                        message.textAlignment = .right
                        message.color = UIColor(named: Constant.BrandColors.blue)
                    } else {
                        message.type = .other
                        message.textAlignment = .left
                        message.color = UIColor(named: Constant.BrandColors.purple)
                    }
                    self?.messages.append(message)
                }
            }
            self?.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        var receiver = ""
        if isUserChat {
            if let admin = adminData {
                receiver = admin.emailChat()
            }
        } else {
            receiver = detailUser.email()
        }
        if let text = messageTextField.text {
            if !text.isEmpty {
                let messagesDB = Database.database().reference().child("messages")
                let messageDictionary = ["sender": Auth.auth().currentUser?.email,
                                         "body": text,
                                         "received": receiver,
                                         "time": dateString]
                messagesDB.childByAutoId().setValue(messageDictionary) { [weak self]
                    (error, reference) in
                    if error != nil {
                        print(error as Any)
                        self?.view.makeToast("Gửi không thành công")
                    } else {
                        print("Message save successfuly")
                        self?.scrollToBottom()
                        self?.messageTextField.text = ""
                    }
                }
            }
        }
    }
    
    func modelIndexPath(_ index: IndexPath) -> Message {
        return messages[index.row]
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message: Message
        message = modelIndexPath(indexPath)
        
        switch message.type {
        case .current:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTableViewCell", for: indexPath) as?
                    CurrentTableViewCell else { return UITableViewCell() }
            cell.setupData(message: message)
            cell.selectionStyle = .none
            return cell
        case .other:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OtherTableViewCell", for: indexPath) as?
                    OtherTableViewCell else { return UITableViewCell() }
            cell.setupData(message: message)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .none {
            
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var message: Message
        message = modelIndexPath(indexPath)
        
        switch message.type {
        case .current:
            let showTimeAction = UIContextualAction(style: .normal, title: message.time) { [weak self] (action, view, completion) in
                completion(true)
            }
            showTimeAction.backgroundColor =  UIColor(named: Constant.BrandColors.lighBlue)
            return UISwipeActionsConfiguration(actions: [showTimeAction])
        default:
            return UISwipeActionsConfiguration()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var message: Message
        message = modelIndexPath(indexPath)
        
        switch message.type {
        case .other:
            let showTimeAction = UIContextualAction(style: .normal, title: message.time) { [weak self] (action, view, completion) in
                completion(true)
            }
            showTimeAction.backgroundColor =  UIColor(named: Constant.BrandColors.lightPurple)
            return UISwipeActionsConfiguration(actions: [showTimeAction])
        default:
            return UISwipeActionsConfiguration()
        }

    }

}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextField.text = ""
    }
}
