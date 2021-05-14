//
//  RecommendCardContent.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/29/21.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

class RecommendCardContent: UIView {
    private var sauna: Sauna
    private let mainColor = Color.Neumorphic.main
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        return background
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.01).cgColor,
                           UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()

    init(withImage image: String?, sauna: Sauna) {
        self.sauna = sauna
        super.init(frame: .zero)
        if let image_url = image {
            imageView.cacheImage(imageUrlString: "\(API.init().imageUrl)\(image_url)")
            initialize()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

  private func initialize() {
    addSubview(backgroundView)
    backgroundView.anchorToSuperview()
    backgroundView.addSubview(imageView)
    let body = UIHostingController(rootView: RecommendCardContentBodyView(sauna: sauna))
    backgroundView.addSubview(body.view)
    
    imageView.snp.makeConstraints { make in
        make.height.equalTo(150)
        make.top.equalToSuperview()
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
    
    }
    body.view.snp.makeConstraints { make in
        make.top.equalTo(imageView.snp.bottom)
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
    }
    applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
    backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let heightFactor: CGFloat = 0.35
    gradientLayer.frame = CGRect(x: 0,
                                 y: (1 - heightFactor) * bounds.height,
                                 width: bounds.width,
                                 height: heightFactor * bounds.height)
  }
}

extension UIView {

  @discardableResult
  func anchor(top: NSLayoutYAxisAnchor? = nil,
              left: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              right: NSLayoutXAxisAnchor? = nil,
              paddingTop: CGFloat = 0,
              paddingLeft: CGFloat = 0,
              paddingBottom: CGFloat = 0,
              paddingRight: CGFloat = 0,
              width: CGFloat = 0,
              height: CGFloat = 0) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false

    var anchors = [NSLayoutConstraint]()

    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
    }
    if let left = left {
      anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
    }
    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
    }
    if let right = right {
      anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
    }
    if width > 0 {
      anchors.append(widthAnchor.constraint(equalToConstant: width))
    }
    if height > 0 {
      anchors.append(heightAnchor.constraint(equalToConstant: height))
    }

    anchors.forEach { $0.isActive = true }

    return anchors
  }

  @discardableResult
  func anchorToSuperview() -> [NSLayoutConstraint] {
    return anchor(top: superview?.topAnchor,
                  left: superview?.leftAnchor,
                  bottom: superview?.bottomAnchor,
                  right: superview?.rightAnchor)
  }
}

extension UIView {

  func applyShadow(radius: CGFloat,
                   opacity: Float,
                   offset: CGSize,
                   color: UIColor = .black) {
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
  }
}
