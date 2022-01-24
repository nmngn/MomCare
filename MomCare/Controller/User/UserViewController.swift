//
//  UserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 22/01/2022.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var model = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNavigationButton()
        configView()
    }
    
    func setupNavigationButton() {
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
//                                       , style: .plain, target: self, action: #selector())
//        navigationItem.leftBarButtonItems = [backItem]
//
//        let rightItem = UIBarButtonItem(image: UIImage(systemName: "trash")?.toHierachicalImage()
//                                        , style: .plain, target: self, action:
//                                        #selector())
//        navigationItem.rightBarButtonItem = rightItem
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: UserInfoTableViewCell.self)
            $0.registerNibCellFor(type: DataInfoTableViewCell.self)
            $0.registerNibCellFor(type: MoreInfoTableViewCell.self)
        }
    }
    
    func setupData() {
        
    }

}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
