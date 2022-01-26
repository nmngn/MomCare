//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import NotificationCenter
import SwiftCSV
import PopupDialog
import Presentr

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var model = [HomeModel]()
    var listUser: [User]? {
        didSet {
            setupData()
            getUserToPushNoti()
            self.tableView?.reloadData()
        }
    }
    
    var sortType = ""
    var contrastColor = UIColor()
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notiModel = [NotificationModel]()
    let repo = Repositories(api: .share)
    let idAdmin = Session.shared.userProfile.idAdmin
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .coverHorizontalFromRight
        customPresenter.dismissTransitionType = .coverHorizontalFromRight
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissAnimated = true
        customPresenter.dismissOnSwipeDirection = .default
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        setupNavigationButton()
        userNotificationCenter.delegate = self
        navigationController?.isNavigationBarHidden = false
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        self.requestNotificationAuthorization()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .default
   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getListUser()
        changeTheme(self.theme)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationButton() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.toHierachicalImage()
                                        , style: .plain, target: self, action: #selector(openMore))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func openMore() {
        let vc = SmallOptionViewController.init(nibName: "SmallOptionViewController", bundle: nil)
        vc.notiModel = self.notiModel
        vc.navigation = self.navigationController ?? UINavigationController()
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(noti: [NotificationModel]) {
        let application = UIApplication.shared
        let notificationContent = UNMutableNotificationContent()
        if noti.count == 1 {
            notificationContent.title = "Thông báo về: \(noti.first?.name ?? "")"
            notificationContent.body =
            "Chú ý: \(noti.first?.name ?? "") đã bước vào tháng cuối( \(noti.first?.dateCalculate ?? ""))\nCần chú ý !"
        } else {
            notificationContent.title = "Thông báo về \(self.notiModel.count) bệnh nhân tháng cuối"
            notificationContent.body =
            "Chú ý: \(self.notiModel.count) bệnh nhân đã bước vào tháng cuối \nCần chú ý !"
        }
        application.applicationIconBadgeNumber = noti.count
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var date = DateComponents()
        date.hour = 7
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        if !noti.isEmpty {
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = NotificationViewController.init(nibName: "NotificationViewController", bundle: nil)
        vc.notiModel = self.notiModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func getUserToPushNoti() {
        self.notiModel.removeAll()
        if let listUser = self.listUser {
            let newList = listUser.filter ({ user in
                let text = updateTime(dateString: user.babyDateBorn)
                if !text.isEmpty {
                    let wStartIndex = text.index(text.startIndex, offsetBy: 0)
                    let wEndIndex = text.index(text.startIndex, offsetBy: 1)
                    let weekData = String(text[wStartIndex...wEndIndex])
                
                    let wResult = Int(weekData) ?? 0 >= 38
                    return wResult
                }
                return false
            })
            for user in newList {
                self.notiModel.append(user.convertToNotiModel())
            }
            self.sendNotification(noti: self.notiModel)
        }
    }
        
    func getListUser(reverse: Bool = false) {
        repo.getAllUser(idAdmin: idAdmin) { [weak self] value in
            switch value {
            case .success(let data):
                if let data = data {
                    let list = data.users?.filter({$0.idAdmin == self?.idAdmin})
                    if !reverse {
                        self?.listUser = list
                    } else {
                        self?.listUser = list?.reversed()
                    }
                }
            case .failure(let error):
                self?.openAlert(error?.errorMessage ?? "")
            }
        }
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: BadgeUserTableViewCell.self)
            $0.registerNibCellFor(type: HomeTitleTableViewCell.self)
            $0.registerNibCellFor(type: SortListTableViewCell.self)
            $0.registerNibCellFor(type: AddUserTableViewCell.self)
            $0.registerNibCellFor(type: BiggerHomeUserTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listUser = self.listUser else { return }
        let newList = listUser.filter ({ user in
            let text = updateTime(dateString: user.babyDateBorn)
            if !text.isEmpty {
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 1)
                let data = String(text[startIndex...endIndex])
                let result = Int(data) ?? 0 >= 36
                return result
            }
            return false
        })
        
        var badge = HomeModel(type: .badge)
        badge.contrastColor = contrastColor
        
        var addUser = HomeModel(type: .addUser)
        addUser.contrastColor = contrastColor
        
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này(\(newList.count))"
        header1.contrastColor = contrastColor
        
        var infoCell = HomeModel(type: .infoUser)
        infoCell.contrastColor = contrastColor
        
        var sort = HomeModel(type: .sort)
        sort.contrastColor = contrastColor
        
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả bệnh nhân(\(listUser.count))"
        header2.contrastColor = contrastColor
        
        model.append(badge)
        model.append(addUser)
        model.append(header1)
        
        for i in 0..<newList.count {
            infoCell.id = newList[i].idUser
            infoCell.address = newList[i].address
            infoCell.avatarImage = loadImageFromDiskWith(fileName: newList[i].avatar)
            infoCell.babyAge = newList[i].babyDateBorn
            infoCell.height = newList[i].height
            infoCell.note = newList[i].note
            infoCell.momBirth = newList[i].momBirth
            infoCell.imagePregnant = loadImageFromDiskWith(fileName: newList[i].imagePregnant)
            infoCell.numberPhone = newList[i].numberPhone
            infoCell.name = newList[i].name
            infoCell.dateSave = newList[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: newList[i].babyDateBorn)
            infoCell.isStar = newList[i].isStar
            model.append(infoCell)
        }
        
        model.append(header2)
        if !listUser.isEmpty {
            model.append(sort)
        }
        
        for i in 0..<listUser.count {
            infoCell.id = listUser[i].idUser
            infoCell.address = listUser[i].address
            infoCell.avatarImage = loadImageFromDiskWith(fileName: listUser[i].avatar)
            infoCell.babyAge = listUser[i].babyDateBorn
            infoCell.height = listUser[i].height
            infoCell.note = listUser[i].note
            infoCell.momBirth = listUser[i].momBirth
            infoCell.imagePregnant = loadImageFromDiskWith(fileName: listUser[i].imagePregnant)
            infoCell.numberPhone = listUser[i].numberPhone
            infoCell.name = listUser[i].name
            infoCell.dateSave = listUser[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: listUser[i].babyDateBorn)
            infoCell.isStar = listUser[i].isStar
            model.append(infoCell)
        }
    }

    @IBAction func searchUser(_ sender: UIBarButtonItem) {
        let vc = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return model[indexPath.row]
    }
    
    func sortListUser() {
        let alert = UIAlertController(title: "Sắp xếp", message: "Chọn cách sắp xếp", preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: "Theo tên", style: .default, handler: { _ in
            self.sortType = "Theo tên"
            if let listUser = self.listUser {
                let items = listUser.sorted{$0.name < $1.name}
                self.listUser?.removeAll()
                self.listUser = items
            }
        })
        let sortDateSave = UIAlertAction(title: "Theo ngày lưu", style: .default, handler: { _ in
            self.sortType = "Theo ngày lưu"
            self.getListUser(reverse: true)
        })
        let sortDateCal = UIAlertAction(title: "Theo tuổi tuần thai", style: .default, handler: { _ in
            self.sortType = "Theo tuổi tuần thai"
            if let listUser = self.listUser {
                let newList = listUser.sorted(by: {$0.updateTime() >
                    $1.updateTime()})
                self.listUser?.removeAll()
                self.listUser = newList
            }
        })
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(sortName)
        alert.addAction(sortDateSave)
        alert.addAction(sortDateCal)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .badge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeUserTableViewCell", for: indexPath) as?
                    BadgeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let list = self.listUser {
                cell.getNumberPatient(list: list, contrastColor: self.contrastColor)
            }
            return cell
        case .addUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserTableViewCell", for: indexPath) as?
                    AddUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiggerHomeUserTableViewCell", for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                cell.setupData(model: model)
            }
            cell.isStar = { [weak self] isStar in
                self?.saveStarStatus(id: model.id, isStar)
            }
            cell.showInfo = { [weak self] age in
                self?.getAgeData(age)
            }
            return cell
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortListTableViewCell", for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            self.sortType == "" ? cell.setupTitle(title: "Sắp xếp", contrastColor: self.contrastColor) : cell.setupTitle(title: self.sortType, contrastColor: self.contrastColor)
            cell.selectSoft = { [weak self] in
                self?.sortListUser()
            }
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTitleTableViewCell", for: indexPath) as?
                    HomeTitleTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .addUser:
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case .infoUser:
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            vc.currentModel = model.convertToDetailModel()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

extension HomeViewController {
    func saveStarStatus(id: String,_ isStar: Bool) {
        repo.makeStar(idUser: id, isStar: isStar) { [weak self] response in
            switch response {
            case .success(_):
                self?.getListUser()
                self?.tableView.reloadData()
            case .failure(let error):
                self?.openAlert(error?.errorMessage ?? "")
            }
        }
    }
    
}

extension HomeViewController {
    func getAgeData(_ age: Int) {
        let path = Bundle.main.path(forResource: "Book1", ofType: "csv")

        do {
            let csv : CSV = try CSV(url: URL(fileURLWithPath: path!))
            let rows = csv.namedRows
            
            for row in rows {
                if let data = row["\(age)"] {
                    let vc = PopupInfoViewController.init(nibName: "PopupInfoViewController", bundle: nil)
                    vc.age = age
                    vc.text = data
                    vc.contrastColor = self.contrastColor
                    let popup = PopupDialog(viewController: vc,
                                            buttonAlignment: .horizontal,
                                            transitionStyle: .fadeIn,
                                            tapGestureDismissal: true,
                                            panGestureDismissal: false)
                    self.present(popup, animated: true, completion: nil)
                }
            }
        } catch {
            print("Parsing CSV file has error \(error)")
        }
    }
}
