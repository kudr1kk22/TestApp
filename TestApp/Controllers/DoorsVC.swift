//
//  DoorsVC.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 20.02.23.
//

import UIKit
import SnapKit
import MaterialActivityIndicator

protocol LabelDidTappedDelegate: AnyObject {
  func updateDoorCell(indexPath: IndexPath)
}

//MARK: - Constants

private enum UIConstants {
  static let rowHeight: CGFloat = 117.0
  static let bottomNavBarOffset: CGFloat = 44.0
}

final class DoorsVC: UIViewController {

  //MARK: - Properties

  private lazy var activityIndicator = MaterialActivityIndicatorView()
  private lazy var navBar = UINavigationBar()
  private lazy var tableView = UITableView(frame: .zero, style: .grouped)
  private let networkService: NetworkService
  private var doorsItems: [DoorsModel] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  //MARK: - Initialization

  init(networkService: NetworkService) {
    self.networkService = networkService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  //MARK: - ViewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()
    commonInit()
    getData()
  }

  private func commonInit() {
    setupUI()
    createNavBar()
    registerCells()
    setupConstraints()
  }

  //MARK: - UI SETUP

  private func setupUI() {
    activityIndicator.color = Colors.activityIndicator
    view.backgroundColor = .white
    view.addSubview(tableView)
    view.addSubview(activityIndicator)
  }

  private func setupConstraints() {
    setNavBarConstraints()
    setTableViewlayout()
    setActivityIndicator()
  }

  //MARK: - Get data

  func getData() {
    activityIndicator.startAnimating()
    networkService.getDoors { result in
      switch result {
      case .success(let models):
        self.doorsItems = models
      case .failure(let error):
        print(error.localizedDescription)
      }
      self.activityIndicator.stopAnimating()
    }
  }
}

//MARK: - UINavigationBarDelegate

extension DoorsVC: UINavigationBarDelegate {
  func createNavBar() {
    navBar.isTranslucent = false
    navBar.delegate = self
    navBar.shadowImage = UIImage()
    let navigationItem = UINavigationItem()
    navigationItem.leftBarButtonItem = makeLeftBarButtonItem()
    navigationItem.rightBarButtonItem = makeRightBarButtonItem()
    navBar.setItems([navigationItem], animated: true)
    view.addSubview(navBar)
  }
}

//MARK: - Bar Buttons

private extension DoorsVC {
  func makeLeftBarButtonItem() -> UIBarButtonItem {
    let companyNameView = CompanyNameView()
    let logoButton = UIBarButtonItem(customView: companyNameView)
    return logoButton
  }

  func makeRightBarButtonItem() -> UIBarButtonItem {
    let button =  UIButton(type: .custom)
    button.setImage(UIImage(named: "settingsButton"), for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    let barButton = UIBarButtonItem(customView: button)
    return barButton
  }
}

//MARK: - Create TableView

extension DoorsVC: UITableViewDelegate {
  private func registerCells() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UIConstants.rowHeight
    tableView.register(WelcomeHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: String(describing: WelcomeHeaderTableViewCell.self))
    tableView.register(DoorsTableViewCell.self, forCellReuseIdentifier: String(describing: DoorsTableViewCell.self))
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = WelcomeHeaderTableViewCell()
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UIScreen.main.bounds.height / 4.0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    updateDoorCell(indexPath: indexPath)
  }
}

extension DoorsVC: LabelDidTappedDelegate {
  func updateDoorCell(indexPath: IndexPath) {
    doorsItems[indexPath.row].status = .unlockingStatus
    networkService.sendDoorOpenVerification { result in
      switch result {
      case .success(let status):
        self.doorsItems[indexPath.row].status = status
        self.tableView.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

//MARK: - UITableViewDataSource

extension DoorsVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    doorsItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DoorsTableViewCell.self), for: indexPath) as? DoorsTableViewCell else {
      return UITableViewCell()
    }
    let item = doorsItems[indexPath.row]
    cell.labelDidTappedDelegate = self
    cell.configure(with: item)

    return cell
  }
}

//MARK: - SETUP UI CONSTRAINTS

private extension DoorsVC {

  func setTableViewlayout() {
    tableView.snp.makeConstraints({ make in
      make.top.equalTo(navBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    })
  }

  func setNavBarConstraints() {
    navBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(UIConstants.bottomNavBarOffset)
    }
  }

  func setActivityIndicator() {
    activityIndicator.snp.makeConstraints { make in
      make.center.equalTo(view.center)
    }
  }
}

