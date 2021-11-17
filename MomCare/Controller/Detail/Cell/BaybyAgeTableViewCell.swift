//
//  BaybyAgeTableViewCell.swift
//  MomCare
//
//  Created by Nam Ngây on 06/07/2021.
//

import UIKit

class BaybyAgeTableViewCell: UITableViewCell {

    @IBOutlet weak var dobLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    
    weak var delegate: DetailUserInfo?
    var cellType: DataType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dobLabel.makeShadow()
        dobLabel.autocorrectionType = .no
        dobLabel.setLeftPaddingPoints(16)
        dobLabel.setRightPaddingPoints(16)
        dobLabel.textColor = .black
        dobLabel.isEnabled = false
        
        ageLabel.makeShadow()
        ageLabel.autocorrectionType = .no
        ageLabel.setLeftPaddingPoints(16)
        ageLabel.setRightPaddingPoints(16)
        ageLabel.textColor = .black
        ageLabel.isEnabled = false
    }

    func setupData(model: DetailModel) {
        self.cellType = model.dataType
        if !model.babyAge.isEmpty {
            dobLabel.text = model.babyAge
            delegate?.sendString(dataType: .babyAge, text: model.babyAge)
            calculateBabyAge(dateString: model.babyAge)
        }
    }
    
    func calculateBabyAge(dateString: String) {
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from:dateString)
        guard let timeLast = date?.millisecondsSince1970 else { return }
        let timeToday = todayDate.millisecondsSince1970
        let result = timeLast - timeToday
        changeMilisToWeek(milis: result)
    }
    
    func changeMilisToWeek(milis: Int64) {
        let toDay = milis / 86400000
        let ageDay = 280 - Int(toDay)
        let week = Int(ageDay / 7)
        let day = Int(ageDay % 7)
        if week == 0 {
            ageLabel.text = "\(day)D"
        } else if day == 0 {
            ageLabel.text = "\(week)W"
        } else {
            ageLabel.text = "\(week)W \(day)D"
        }
        delegate?.sendString(dataType: .dateCalculate, text: "\(week)W \(day)D")
    }
    
    @IBAction func chooseDOB(_ sender: UIButton) {
        delegate?.chooseBabyDOB()
    }
}
