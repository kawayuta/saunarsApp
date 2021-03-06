//
//  TinderButton.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 5/1/21.
//

import PopBounceButton

class TinderButton: PopBounceButton {

  override init() {
    super.init()
    adjustsImageWhenHighlighted = false
    backgroundColor = .white
    layer.masksToBounds = true
  }

  required init?(coder aDecoder: NSCoder) {
    return nil
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.cornerRadius = frame.width / 20
  }
}
