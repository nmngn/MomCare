//
//  PopupCalendarViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 11/07/2021.
//

import UIKit

class PopupCalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: UIDatePicker!
    
    var openCalendar: (() -> ())?
    var closeCalendar: (() -> ())?
    var selectDate: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .wheels
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        openCalendar?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        closeCalendar?()
    }
    
    
    func doneDatePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.Text.dateFormat
        let todaysDate = dateFormatter.string(from: calendar.date)
        selectDate?(todaysDate)
        closeCalendar?()
    }
    
    @IBAction func selectDay(_ sender: UIButton) {
        dismiss(animated: true) {
            self.doneDatePicker()
        }
    }
    
}
