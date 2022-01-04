//
//  Other+.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import Foundation
import RealmSwift
import UIKit

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

extension UIViewController {
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
            self.view.backgroundColor = .clear
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 5 {
                theme.image = UIImage(named: "time1")
            } else if hour >= 5 && hour < 7 {
                theme.image = UIImage(named: "time2")
            } else if hour >= 7 && hour < 9 {
                theme.image = UIImage(named: "time3")
            } else if hour >= 9 && hour < 17 {
                theme.image = UIImage(named: "time4")
            } else if hour >= 17 && hour < 19 {
                theme.image = UIImage(named: "time5")
            } else if hour >= 19 && hour < 23 {
                theme.image = UIImage(named: "time2")
            } else {
                theme.image = UIImage(named: "time1")
            }
        }
    }
}
