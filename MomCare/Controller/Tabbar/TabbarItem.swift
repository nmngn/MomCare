//
//  TabbarItem.swift
//  MomCare
//
//  Created by Nam Nguyễn on 02/07/2022.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable {
    case home = "Home"
    case chat = "Chat"
    case noti = "Notification"
    case account = "Account"

    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .chat:
            return ChatViewController()
        case .noti:
            return NotificationViewController()
        case .account:
            return AdminViewController()
        }
    }

    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
        case .chat:
            return UIImage(systemName: "message")!
        case .noti:
            return UIImage(systemName: "bell")!
        case .account:
            return UIImage(systemName: "person")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
