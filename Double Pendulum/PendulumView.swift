//
//  PendulumView.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

class PendulumView: UIView {
    // physical model
    var pendulum = DoublePendulum()
    
    // link to display refresh rate timer
    var link: CADisplayLink? = nil { didSet {
        guard link != oldValue else { return }
        if let link = oldValue { link.invalidate() }
        if let link = link { link.add(to: .current, forMode: .defaultRunLoopMode) }
    } }
    
    // clean up
    deinit { link = nil }
    
    // runtime initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let link = CADisplayLink(target: self, selector: #selector(step))
        link.preferredFramesPerSecond = UIScreen.main.maximumFramesPerSecond
        self.link = link
    }
    
    // draw double pendulum
    override func draw(_ rect: CGRect) {
        StyleKit.drawDoublePendulum(frame: rect, phi: CGFloat(pendulum.phi), psi: CGFloat(pendulum.psi), upsilon: CGFloat(pendulum.upsilon))
    }
    
    // pendulum state update
    @objc func step(link: CADisplayLink) {
        let dt = (link.targetTimestamp - link.timestamp)/32
        for _ in 0..<32 { pendulum.step(dt) }; setNeedsDisplay()
    }
}
