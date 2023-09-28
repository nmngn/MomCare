//
//  AppManager.swift
//  MomCare
//
//  Created by NamNT1 on 27/09/2023.
//

import Foundation

class AppManager {
    
    static let shared = AppManager()
    
    fileprivate var hourNoti = 7
    fileprivate var minuteNoti = 30
    fileprivate var isEditting = true
    
    func getTime() -> (hour: Int, minute: Int) {
        if let hour = UserDefaults.standard.value(forKey: Constant.Text.hourToPushNoti) as? Int,
            let minute = UserDefaults.standard.value(forKey: Constant.Text.minuteToPushNoti) as? Int {
             return (hour, minute)
        } else {
            return (hourNoti, minuteNoti)
        }
    }
    
    func setTimeToPushNoti(hour: Int, minute: Int) {
        UserDefaults.standard.set(hour, forKey: Constant.Text.hourToPushNoti)
        UserDefaults.standard.set(minute, forKey: Constant.Text.minuteToPushNoti)
    }
    
    func getIsEdittingValue() -> Bool {
        if let isEditting = UserDefaults.standard.value(forKey: Constant.Text.isEdittingImage) as? Bool {
            return isEditting
        } else {
            return self.isEditting
        }
    }
    
    func setIsEdittingValue(isEditting: Bool) {
        UserDefaults.standard.set(isEditting, forKey: Constant.Text.isEdittingImage)
    }
}
