//
//  WelcomeHeaderTableViewCell.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 21.02.23.
//

import UIKit

final class WelcomeHeaderTableViewCell: UITableViewHeaderFooterView {
  
  //MARK: - Initialization
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    initializeConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Properties
  
  private let welcomeLabel: UILabel = {
    let label = UILabel()
    label.text = TextConstants.welcome
    label.font = UIFont(name: "Sk-Modernist-Bold", size: 35.0)
    return label
  }()
  
  private let homeImage: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "Home")
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  private let myDoorsLabel: UILabel = {
    let label = UILabel()
    label.text = TextConstants.myDoors
    label.font = UIFont(name: "Sk-Modernist-Bold", size: 20.0)
    return label
  }()
}

extension WelcomeHeaderTableViewCell {
  private func initializeConstraints() {
    contentView.addSubview(welcomeLabel)
    welcomeLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(24)
      make.centerY.equalToSuperview()
    }
    
    contentView.addSubview(homeImage)
    homeImage.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.trailing.equalToSuperview().inset(4)
    }
    
    contentView.addSubview(myDoorsLabel)
    myDoorsLabel.snp.makeConstraints { make in
      make.leading.equalTo(welcomeLabel.snp.leading)
      make.bottom.equalToSuperview()
    }
  }
}
