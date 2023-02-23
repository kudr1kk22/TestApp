//
//  DoorsTableViewCell.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 20.02.23.
//

import UIKit
import MaterialActivityIndicator

private enum Constants {
  static let contentInset: CGFloat = 22.0
  static let guardDoorSize: CGFloat = 41.0
  static let safeAreaInset: CGFloat = 16.0
  static let topBottomCellInset: CGFloat = 7.0
}

final class DoorsTableViewCell: UITableViewCell {

  //MARK: - Properties

  weak var labelDidTappedDelegate: LabelDidTappedDelegate?

  private lazy var activityIndicator = MaterialActivityIndicatorView()

  private let guardDoorState: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "iconLocked")
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let doorState: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "doorIconLocked")
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let stateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Sk-Modernist-Regular", size: 15.0)
    label.textColor = Colors.locked
    return label
  }()

  private let doorTypeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Sk-Modernist-Regular", size: 16.0)
    label.textColor = Colors.doorType
    return label
  }()

  private let doorLocationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Sk-Modernist-Regular", size: 14.0)
    label.textColor = Colors.location
    return label
  }()

  //MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
    cellUIStyle()
    setGesture()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Action

  private func setGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
    stateLabel.isUserInteractionEnabled = true
    stateLabel.addGestureRecognizer(tapGesture)
  }

  @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
    if let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
      labelDidTappedDelegate?.updateDoorCell(indexPath: indexPath)
    }
  }

  //MARK: - Configure cell

  func configure(with model: DoorsModel) {
    stateLabel.text = "\(model.status.rawValue)"
    doorTypeLabel.text = model.name
    doorLocationLabel.text = model.location.rawValue
    setupState(with: model)
  }

  func cellUIStyle() {
    activityIndicator.color = Colors.activityIndicator
    backgroundColor = .clear
    contentView.layer.cornerRadius = 15
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = Colors.borderCell.cgColor
  }

  //MARK: - Setup State for cell

  private func setupState(with model: DoorsModel) {
    switch model.status {
    case .lockedStatus:
      guardDoorState.image = UIImage(named: "iconLocked")
      stateLabel.textColor = Colors.locked
      doorState.image = UIImage(named: "doorIconLocked")
    case .unlockingStatus:
      doorState.isHidden = true
      guardDoorState.image = UIImage(named: "doorIconWait")
      stateLabel.textColor = Colors.unlocking
      activityIndicator.startAnimating()
    case .unlockedStatus:
      doorState.isHidden = false
      doorState.image = UIImage(named: "doorIconUnlocked")
      guardDoorState.image = UIImage(named: "iconUnlocked")
      stateLabel.textColor = Colors.unlocked
      activityIndicator.stopAnimating()
    }
  }
}

extension DoorsTableViewCell {
  private func initialize() {
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: Constants.topBottomCellInset, left: Constants.safeAreaInset, bottom: Constants.topBottomCellInset, right: Constants.safeAreaInset))
    }

    contentView.addSubview(guardDoorState)
    guardDoorState.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(Constants.contentInset)
      make.size.equalTo(Constants.guardDoorSize)
    }

    contentView.addSubview(stateLabel)
    stateLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(Constants.contentInset / 2)
    }

    contentView.addSubview(doorTypeLabel)
    doorTypeLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(Constants.contentInset)
      make.leading.equalTo(guardDoorState.snp.trailing).inset(-14.0)
    }

    contentView.addSubview(doorLocationLabel)
    doorLocationLabel.snp.makeConstraints { make in
      make.top.equalTo(doorTypeLabel.snp.bottom)
      make.leading.equalTo(doorTypeLabel.snp.leading)
    }

    contentView.addSubview(doorState)
    doorState.snp.makeConstraints { make in
      make.top.equalTo(guardDoorState.snp.top)
      make.trailing.equalToSuperview().inset(19)
    }

    contentView.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalTo(doorState)
    }
  }
}
