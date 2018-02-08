//
//  PendulumView.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

class PendulumView: UIView {
    @objc dynamic var phi: Float = 0.0 { didSet { if phi != oldValue { setNeedsDisplay() } } }
    @objc dynamic var psi: Float = 0.0 { didSet { if psi != oldValue { setNeedsDisplay() } } }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        StyleKit.drawDoublePendulum(frame: rect, phi: CGFloat(phi), psi: CGFloat(psi))
    }

}
