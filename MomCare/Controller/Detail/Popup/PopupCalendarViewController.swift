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

    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        openCalendar?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        closeCalendar?()
    }
    
    func showDatePicker(){
        //Formate Date
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .wheels
    }
    
    func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.view.endEditing(true)
        closeCalendar?()
    }
    
    @IBAction func selectDay(_ sender: UIButton) {
        dismiss(animated: true) {
            self.doneDatePicker()
        }
    }
    
}
