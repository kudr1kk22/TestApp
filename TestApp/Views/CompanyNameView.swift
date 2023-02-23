//
//  CompanyNameView.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 23.02.23.
//

import UIKit

final class CompanyNameView: UIView {

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: .zero)
    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Properties

  private let companyNameLabel: UILabel = {
    let label = UILabel()
    label.text = TextConstants.companyName
    label.textColor = Colors.companyName
    label.font = UIFont(name: "Sk-Modernist-Bold", size: 18.0)
    return label
  }()

  private let companyImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "QR")
    return image
  }()

  //MARK: - Constraints

  private func initialize() {
    addSubview(companyNameLabel)
    companyNameLabel.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
    }

    addSubview(companyImageView)
    companyImageView.snp.makeConstraints { make in
      make.top.trailing.bottom.equalToSuperview()
      make.leading.equalTo(companyNameLabel.snp.trailing).inset(-4)
      make.height.equalTo(16)
    }
  }
}
