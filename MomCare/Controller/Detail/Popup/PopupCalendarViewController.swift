//
//  PopupCalendarViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 11/07/2021.
//

import UIKit

class PopupCalendarViewController: UIViewController {
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var calendar: UIDatePicker!
    
    var selectDate: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .wheels
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        transparentView.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    func doneDatePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.Text.dateFormat
        let todaysDate = dateFormatter.string(from: calendar.date)
        selectDate?(todaysDate)
        self.dismiss(animated: true)
    }
    
    @IBAction func selectDay(_ sender: UIButton) {
        dismiss(animated: true) {
            self.doneDatePicker()
        }
    }
}
