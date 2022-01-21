//
//  AdminViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 20/01/2022.
//

import UIKit

class AdminViewController: DetailUserViewController {

    override func setupData() {
        model.removeAll()
        var avatar = currentModel
        avatar.type = .avatar
        avatar.dataType = .momImage
//        avatar.avatarImage = adminInfo.userImage == nil ? UIImage(named: "avatar_placeholder") : adminInfo.userImage
        avatar.contrastColor = contrastColor
        
        var name = currentModel
        name.type = .info
        name.dataType = .name
        name.title = "Họ và tên"
//        name.value = adminInfo.userName
        name.contrastColor = contrastColor
        
        var address = currentModel
        address.type = .info
        address.dataType = .address
        address.title = "Địa chỉ"
//        address.value = adminInfo.userAddress
        address.contrastColor = contrastColor
        
        var number = currentModel
        number.type = .info
        number.dataType = .numberPhone
        number.title = "Số điện thoại ⃰"
        number.isEnable = false
        number.value = adminInfo.userNumberPhone
        number.contrastColor = contrastColor
        
        var email = currentModel
        email.type = .info
        email.dataType = .height // height luu cho email
        email.title = "Email"
//        email.value = adminInfo.userEmail
        email.contrastColor = contrastColor
        
        model.append(avatar)
        model.append(name)
        model.append(number)
        model.append(email)
        model.append(address)
    }
    
    override func setupView() {
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        self.title = "Thông tin cá nhân"
    }
    
    @IBAction override func saveData(_ sender: UIButton) {
        view.makeToast("Cập nhật thành công")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
