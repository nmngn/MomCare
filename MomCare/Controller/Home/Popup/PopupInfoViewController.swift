//
//  PopupInfoViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/01/2022.
//

import UIKit

class PopupInfoViewController: UIViewController {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var age: Int? {
        didSet {
            setupData()
        }
    }
    
    var text: String? {
        didSet {
            setupData()
        }
    }
    
    var contrastColor: UIColor? {
        didSet {
            setupData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        weekLabel?.text = "Tuần thai thứ \(age ?? 0)"
        descriptionLabel?.text = text ?? ""
        weekLabel?.textColor = contrastColor
        descriptionLabel?.textColor = contrastColor
    }
}
