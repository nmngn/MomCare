//
//  Constant.swift
//  MomCare
//
//  Created by Nam Ngây on 21/01/2022.
//

import Foundation
import UIKit

enum Constant {
    enum BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
        
        static let darkColorItem =  UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.00)
        
        static let lightColorBadge = UIColor(red: 0.38, green: 0.64, blue: 0.74, alpha: 1.00)
        static let darkColorBadge = UIColor(red: 0.34, green: 0.35, blue: 0.73, alpha: 1.00)
        
        static let lightColorItem2 = UIColor(red: 0.45, green: 0.66, blue: 0.85, alpha: 1.00)
        static let darkColorItem2 = UIColor(red: 0.36, green: 0.30, blue: 0.59, alpha: 1.00)
    }
    
    enum Text {
        static let bell = "bell"
        static let badgeBell = "bell.badge"
        static let dune = "dune"
        static let listBullet = "list.bullet"
        static let avatarPlaceholder = "avatar_placeholder"
        static let star = "star"
        static let unStar = "unstart"
        static let icBack = "ic_left_arrow"
        static let icTrash = "trash"
        
        static let hello = "Xin chào "
        static let allPatient = "Tổng số sản phụ hiện có: "
        static let patientInMonth = "Số sản phụ dự kiến sinh trong tháng này: "
        static let notUpdated = "Chưa cập nhật"
        static let home = "Màn hình chính"
        static let notificationAbout = "Thông báo về "
        static let notificationEn = "Notification"
        static let notification = "Thông báo"
        static let sort = "Sắp xếp"
        static let chooseSortType = "Chọn cách sắp xếp"
        static let sortName = "Theo tên"
        static let sortDate = "Theo ngày lưu"
        static let sortAge = "Theo tuổi tuần thai"
        static let cancel = "Hủy bỏ"
        static let dateCreated = "Ngày đăng kí: "
        static let patientInfo = "Thông tin sản phụ"
        static let patientNotSave = "Sản phụ chưa được lưu lại"
        static let saveIt = "Lưu lại"
        static let accept = "Đồng ý"
        static let removeUser = "Bạn có muốn xóa sản phụ này ?"
        static let save = "Lưu"
        static let saveChange = "Lưu thay đổi"
        static let name = "Họ và tên ⃰"
        static let address =  "Địa chỉ ⃰"
        static let yearBorn = "Năm sinh ⃰"
        static let phone = "Số điện thoại ⃰"
        static let height = "Chiều cao ⃰"
        static let missingInfo = "Đang thiếu thông tin"
        static let understand = "Đã hiểu"
        static let historyVC = "Lịch sử ghi chú"
        static let noted = "Các ghi chú đã ghi"
        static let search = "Tìm kiếm"
        static let letSearch = "Hãy bắt đầu tìm kiếm"
        static let noResult = "Không có kết quả tìm thấy"
        static let noNotify = "Không có thông báo"
        
        static let dateFormat = "dd/MM/yyyy"
        static let dateFormatDetail = "dd/MM/yyyy HH:mm:ss"
    }
    
    enum Size {
        static let normalFontSize: CGFloat = 16
        static let biggerFontSize: CGFloat = 18
    }
}
