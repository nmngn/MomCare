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
    
    func changeTheme(_ theme: UIImageView) {
        DispatchQueue.main.async {
            if self.traitCollection.userInterfaceStyle == .light {
                theme.backgroundColor = .lightGray
            } else {
                theme.backgroundColor = .darkGray
            }
        }
    }
    
    func loading() {
        let alert = UIAlertController(title: nil, message: "Vui lòng đợi...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoading() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openAlert(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
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
