//
//  ChatViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var theme : UIImageView!
    
    var messages : [Message] = []
    var detailUser = DetailModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        loadMessage()
        changeTheme(theme)
        theme.applyBlurEffect()
        setupNavigationButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = detailUser.name
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
        if let url = URL(string: "telprompt://\(self.detailUser.numberPhone)"),
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
            self.bottomHeightConstraint.constant = keyboardHeight - 18
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
            $0.registerNibCellFor(type: ChatTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
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
    
    func loadMessage(){
        let messageDB = Database.database().reference().child("messages")

        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let received = snapshotValue["received"] ?? ""
            let text = snapshotValue["body"] ?? ""
            let sender = snapshotValue["sender"] ?? ""
            
            print(text, sender, received)
            if received == self.detailUser.email() {
                var message = Message()
                message.body = text
                message.sender = sender
                message.received = received
                self.messages.append(message)
            }
            self.tableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
        if let text = messageTextField.text {
            if !text.isEmpty {
                let messagesDB = Database.database().reference().child("messages")
                let messageDictionary = ["sender": Auth.auth().currentUser?.email,
                                         "body": text,
                                         "received": detailUser.email()]
                messagesDB.childByAutoId().setValue(messageDictionary) {
                    (error, reference) in
                    if error != nil {
                        print(error as Any)
                        self.view.makeToast("Gửi không thành công")
                    } else {
                        print("Message save successfuly")
                        self.scrollToBottom()
                        self.messageTextField.text = ""
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as?
                ChatTableViewCell else { return UITableViewCell() }
        cell.setupData(message: message)
        cell.selectionStyle = .none
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextField.text = ""
    }
}
