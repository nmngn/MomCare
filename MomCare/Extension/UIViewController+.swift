//
//  UIViewController+.swift
//  MomCare
//
//  Created by NamNT1 on 29/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func transitionVC(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    
    func showNoticeAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(title: String, message: String, confirmTitle: String = "", completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: confirmTitle.isEmpty ? "OK" : confirmTitle, style: .default) { _ in
            completion?()
        }
        
        let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

func updateTime(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    let todayDate = Date()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date = dateFormatter.date(from: dateString)
    guard let timeLast = date?.millisecondsSince1970 else { return ""}
    let timeToday = todayDate.millisecondsSince1970
    let result = timeLast - timeToday
    
    let toDay = result / 86400000
    let ageDay = 280 - Int(toDay)
    let week = Int(ageDay / 7)
    let day = Int(ageDay % 7)
    return week < 10 ?  "0\(week)W \(day)D" : "\(week)W \(day)D"
}

func getCurrentMonth() -> Int {
    let monthInt = Calendar.current.component(.month, from: Date())
    return monthInt
}

func getCurrentDate() -> String {
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constant.Text.dateFormatDetail
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    return dateString
}
