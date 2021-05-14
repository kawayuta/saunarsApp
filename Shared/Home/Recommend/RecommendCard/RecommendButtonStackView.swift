//
//  RecommendButtonStackView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 5/1/21.
//

import Foundation
import PopBounceButton
import SwiftUI
import SnapKit

protocol ButtonStackViewDelegate: AnyObject {
  func didTapButton(button: TinderButton)
}

class ButtonStackView: UIStackView {

  weak var delegate: ButtonStackViewDelegate?

  private let undoButton: TinderButton = {
    let button = TinderButton()
    button.setImage(UIImage(named: "undo"), for: .normal)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    button.tag = 1
    return button
  }()

  private let passButton: TinderButton = {
    let button = TinderButton()
    button.setImage(UIImage(named: "pass"), for: .normal)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    button.tag = 2
    button.backgroundColor = Color(hex:"bbb").toUIColor()
    button.setTitle("う〜ん", for: .normal)
    return button
  }()

  private let superLikeButton: TinderButton = {
    let button = TinderButton()
    button.setImage(UIImage(named: "star"), for: .normal)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    button.tag = 3
    return button
  }()

  private let likeButton: TinderButton = {
    let button = TinderButton()
    button.setImage(UIImage(named: "heart"), for: .normal)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    button.tag = 4
    button.backgroundColor = UIColor.blue
    button.setTitle("イキタイ！", for: .normal)
    return button
  }()

  private let boostButton: TinderButton = {
    let button = TinderButton()
    button.setImage(UIImage(named: "lightning"), for: .normal)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    button.tag = 5
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    distribution = .equalSpacing
    alignment = .center
    configureButtons()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureButtons() {
    let largeMultiplier: CGFloat = 66 / 414 //based on width of iPhone 8+
    let smallMultiplier: CGFloat = 54 / 414 //based on width of iPhone 8+§
    addArrangedSubview(from: passButton, diameterMultiplier: largeMultiplier)
    addArrangedSubview(from: likeButton, diameterMultiplier: largeMultiplier)
  }

  private func addArrangedSubview(from button: TinderButton, diameterMultiplier: CGFloat) {
    let container = ButtonContainer()
    container.addSubview(button)
    button.snp.makeConstraints { make in
        make.height.equalTo(60)
        make.width.equalTo(160)
        make.top.equalToSuperview()
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
    }
    addArrangedSubview(container)
    container.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.leading.equalTo(button.snp.leading)
        make.trailing.equalTo(button.snp.trailing)
        make.bottom.equalTo(button.snp.bottom)
    }
  }

  @objc
  private func handleTap(_ button: TinderButton) {
    delegate?.didTapButton(button: button)
  }
}

private class ButtonContainer: UIView {

  override func draw(_ rect: CGRect) {
    applyShadow(radius: 0.2 * bounds.width, opacity: 0.05, offset: CGSize(width: 0, height: 0.15 * bounds.width))
  }
}
