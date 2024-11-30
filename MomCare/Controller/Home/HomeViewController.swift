//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import PopupDialog
import Presentr
import RealmSwift
import Toast_Swift
import RxSwift

class HomeViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    let disposedBag = DisposeBag()
    let viewModel: HomeViewModel = HomeViewModel()
        
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
        self.setupNavigationButton()
        self.configView()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewModel.getListUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupNavigationButton()
        self.tableView.reloadData()
    }
    
    func bindViewModel() {
        viewModel.listUserData.asObservable().subscribe { [weak self] value in
            self?.viewModel.getListHomeData()
            self?.viewModel.getUserToPushNoti()
        }.disposed(by: disposedBag)
        
        viewModel.listHomeData.asObservable().subscribe { [weak self] value in
            self?.tableView.reloadData()
        }.disposed(by: disposedBag)
    }
    
    func setupNavigationButton() {
        self.title = Constant.Text.home
        self.navigationController?.isNavigationBarHidden = false

        let rightItem = UIBarButtonItem(image: UIImage(systemName: Constant.Text.listBullet)?.toHierachicalImage()
                                        , style: .plain, target: self, action: #selector(openMore))
        navigationItem.rightBarButtonItem = rightItem
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func openMore() {
        let vc = SmallOptionViewController.init(nibName: SmallOptionViewController.className, bundle: nil)
        let data = Array(Set(viewModel.listNotificationData.value + viewModel.listCustomNotificationData.value))
        vc.notiModel = data
        vc.navigation = self.navigationController ?? UINavigationController()
        customPresentViewController(presenter, viewController: vc, animated: true)
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
        viewModel.localNotificationCenter.delegate = self
    }
    
    @IBAction func searchUser(_ sender: UIBarButtonItem) {
        let vc = SearchViewController.init(nibName: SearchViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return viewModel.listHomeData.value[indexPath.row]
    }
    
    func sortListUser() {
        let alert = UIAlertController(title: Constant.Text.sort, message: Constant.Text.chooseSortType, preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: Constant.Text.sortName, style: .default, handler: {[weak self] _ in
            self?.viewModel.sortType.accept(.name)
            let listUser = self?.viewModel.listUserData.value
            if let items = listUser?.sorted(by: {$0.name < $1.name}) {
                self?.viewModel.listUserData.accept(items)
            }
        })
        let sortDateSave = UIAlertAction(title: Constant.Text.sortDate, style: .default, handler: {[weak self] _ in
            self?.viewModel.sortType.accept(.date)
            let listUser = self?.viewModel.listUserData.value
            if let items = listUser?.sorted(by: {$0.dateSave > $1.dateSave}) {
                self?.viewModel.listUserData.accept(items)
            }
        })
        let sortDateCal = UIAlertAction(title: Constant.Text.sortAge, style: .default, handler: {[weak self] _ in
            self?.viewModel.sortType.accept(.age)
            let listUser = self?.viewModel.listUserData.value
            if let newList = listUser?.sorted(by: {
                updateTime(dateString: $0.babyDateBorn) > updateTime(dateString: $1.babyDateBorn)
            }) {
                self?.viewModel.listUserData.accept(newList)
            }
        })
        let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: { _ in
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
        return viewModel.listHomeData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .badge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BadgeUserTableViewCell.className, for: indexPath) as?
                    BadgeUserTableViewCell else { return UITableViewCell() }
            let list = self.viewModel.listUserData.value
            cell.selectionStyle = .none
            cell.getNumberPatient(list: list)
            return cell
        case .addUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddUserTableViewCell.className, for: indexPath) as?
                    AddUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BiggerHomeUserTableViewCell.className, for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            cell.isStar = { [weak self] isStar in
                self?.saveStarStatus(id: model.id, isStar)
            }
            cell.showNotificationTime = {[weak self] value in
                self?.showAlert(text: value)
            }
            return cell
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortListTableViewCell.className, for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            viewModel.sortType.value == .normal
            ? cell.setupTitle(title: Constant.Text.sort)
            : cell.setupTitle(title: viewModel.sortType.value.toText())
            cell.selectSoft = { [weak self] in
                self?.sortListUser()
            }
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTitleTableViewCell.className, for: indexPath) as?
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
            let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case .infoUser:
            let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
            vc.currentModel.id = model.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .infoUser:
            let action = UIContextualAction(style: .normal, title: nil) {[weak self] _, _, _ in
                self?.showConfirmAlert(title: Constant.Text.notification, message: "Bạn có muốn dánh dấu đã sinh?", completion: {[weak self] in
                    self?.viewModel.moveToBorn(id: model.id)
                })
            }
            
            action.image = UIImage(systemName: "person.fill.checkmark")
            action.backgroundColor = UIColor(named: "Background")
            let swipeActions = UISwipeActionsConfiguration(actions: [action])
            return swipeActions
        default:
            break
        }
        return nil
    }
}

extension HomeViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Thông báo vào: " + text, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveStarStatus(id: String,_ isStar: Bool) {
        self.viewModel.saveStarStatus(id: id, isStar)
    }
}

extension HomeViewController: UNUserNotificationCenterDelegate {
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        viewModel.localNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = NotificationViewController.init(nibName: NotificationViewController.className, bundle: nil)
        vc.notiModel = viewModel.listNotificationData.value
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
