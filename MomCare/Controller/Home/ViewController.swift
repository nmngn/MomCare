//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import Then

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    var model = [HomeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
        }
    }
    
    func setupData() {
        
    }


    @IBAction func searchUser(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func openCalculate(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addUser(_ sender: UIButton) {
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
