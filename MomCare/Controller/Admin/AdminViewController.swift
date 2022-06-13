//
//  AdminViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/01/2022.
//

import UIKit

class AdminViewController: DetailUserViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataAdmin()
        saveAdminImage = true
    }
    
    override func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    func getDataAdmin() {
        repo.getOneAdmin(idAdmin: idAdmin) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    self?.currentModel = data.convertToDetailModel()
                    DispatchQueue.main.async {
                        self?.setupData()
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error as Any)
                self?.openAlert(error?.errorMessage ?? "")
            }
        }
    }
    
    override func setupData() {
        model.removeAll()
        var avatar = currentModel
        avatar.type = .avatar
        avatar.dataType = .momImage
        avatar.avatarImage = loadImageFromDiskWith(fileName: "adminImage_\(idAdmin)") ?? UIImage(named: "avatar_placeholder")
        
        var name = currentModel
        name.type = .info
        name.dataType = .name
        name.title = "Họ và tên"
        name.value = currentModel.name
        
        var address = currentModel
        address.type = .info
        address.dataType = .address
        address.title = "Địa chỉ"
        address.value = currentModel.address
        
        var number = currentModel
        number.type = .info
        number.dataType = .numberPhone
        number.title = "Số điện thoại( Không thay đổi)"
        number.value = currentModel.numberPhone
        number.isActive = false
        
        var email = currentModel
        email.type = .info
        email.dataType = .height // height luu cho email
        email.title = "Email"
        email.value = currentModel.height
        
        model.append(avatar)
        model.append(name)
        model.append(number)
        model.append(email)
        model.append(address)
    }
    
    override func setupView() {
        self.title = "Thông tin cá nhân"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction override func saveData(_ sender: UIButton) {
        var avatar = UIImage(named: "avatar_placeholder")!
        if let image = currentModel.avatarImage {
            avatar = image
        }
        repo.updateAdmin(idAdmin: idAdmin, avatar: saveImage(imageName: "adminImage_\(idAdmin)", image: avatar, type: .mom),
                         name: currentModel.name, address: currentModel.address,
                         email: currentModel.height) { [weak self] value in
            switch value {
            case.success(let data):
                print(data as Any)
                self?.view.makeToast("Cập nhật thành công")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.navigationController?.popToRootViewController(animated: true)
                    Session.shared.isPopToRoot = true
                }
            case .failure(let error):
                print(error as Any)
                self?.openAlert(error?.errorMessage ?? "")
            }
        }
    }
}
