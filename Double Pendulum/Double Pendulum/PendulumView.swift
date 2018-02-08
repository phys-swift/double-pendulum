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
        link.preferredFramesPerSecond = 30; self.link = link
    }
    
    // draw double pendulum
    override func draw(_ rect: CGRect) {
        StyleKit.drawDoublePendulum(frame: rect, phi: CGFloat(phi), psi: CGFloat(psi))
    }
    
    // pendulum state update
    @objc func step() { phi += 0.5; psi += 1.3 }
}
