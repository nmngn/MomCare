//
//  SettingTimeTableViewCell.swift
//  MomCare
//
//  Created by NamNT1 on 27/09/2023.
//

import UIKit

class SettingTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeView: UIDatePicker!
    
    var timeChanged: (((hour: Int, minute: Int)) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeView.addTarget(self, action: #selector(timeChange), for: .valueChanged)
    }
    
    func setupData(model: SettingModel) {
        titleLabel.text = model.title
            
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.hour, .minute], from: Date())
        (components.hour, components.minute) = AppManager.shared.getTime()
        if let data = calendar.date(from: components) {
            self.timeView.setDate(data, animated: true)
        }
    }
    
    @objc func timeChange(sender: UIDatePicker) {
        let date = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        self.timeChanged?((hour, minute))
    }
}
