//
//  PendulumView.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

class PendulumView: UIView {
    // MARK: physical model
    var pendulum = DoublePendulum()
    var trace = History(size: 50, step: UIScreen.main.maximumFramesPerSecond/10)
    
    // MARK: simulation states
    enum State: Int { case running, dragging, paused }
    
    var simulation = State.running { didSet {
        guard simulation != oldValue else { return }
        link?.isPaused = (simulation == .paused)
    } }
    
    // MARK: gesture recognizers
    var pause = UITapGestureRecognizer()
    var press = UILongPressGestureRecognizer()
    
    // MARK: interface to view controller
    @objc dynamic var displayTrace = true
    
    @objc dynamic var phi: Float {
        get { return Float(pendulum.phi) }
        set { pendulum.phi = Double(newValue); trace.reset() }
    }
    
    @objc dynamic var psi: Float {
        get { return Float(pendulum.psi) }
        set { pendulum.psi = Double(newValue); trace.reset() }
    }
    
    // MARK: link to display refresh rate timer
    var link: CADisplayLink? = nil { didSet {
        guard link != oldValue else { return }
        if let link = oldValue { link.invalidate() }
        if let link = link { link.add(to: .current, forMode: .defaultRunLoopMode) }
    } }
    
    // MARK: clean up
    deinit { link = nil }
    
    // MARK: runtime initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // activate display link
        let link = CADisplayLink(target: self, selector: #selector(step))
        link.preferredFramesPerSecond = UIScreen.main.maximumFramesPerSecond
        self.link = link
        
        // ...
        pause.addTarget(self, action: #selector(stop)); addGestureRecognizer(pause)
        press.addTarget(self, action: #selector(drag)); addGestureRecognizer(press)
    }
    
    // MARK: draw double pendulum
    override func draw(_ rect: CGRect) {
        StyleKit.drawDoublePendulum(frame: rect, phi: CGFloat(pendulum.phi), psi: CGFloat(pendulum.psi), upsilon: CGFloat(pendulum.upsilon))
        if displayTrace { drawTrajectory(frame: rect, trace: trace) }
    }
    
    // MARK: draw pendulum trajectory
    func drawTrajectory(frame rect: CGRect, trace: History, color: UIColor = UIColor.red) {
        guard trace.count > 1, let context = UIGraphicsGetCurrentContext() else { return }
        
        // save context
        context.saveGState()
        
        // rescale the pendulum coordinates to fit view frame
        let canvas = CGRect(x: -2, y: -2, width: 4, height: 4)
        let resized = StyleKit.ResizingBehavior.aspectFit.apply(rect: canvas, target: frame)
        context.translateBy(x: resized.minX-frame.minX, y: resized.minY-frame.minY)
        context.scaleBy(x: resized.width/canvas.width, y: resized.height/canvas.height)
        context.translateBy(x: -canvas.minX, y: -canvas.minY)
        context.scaleBy(x: 528.0/640.0, y: -528.0/640.0)
        
        // total duration of the stored trace
        let (t0,_) = trace[0], (t8,_) = trace[trace.count-1]
        
        // draw trace
        for i in 0..<trace.count-1 {
            // control point coordinates
            let (t1,q1) = trace[i], (t2,q2) = trace[i+1], dt = (t2-t1)/3.0, alpha = (t2-t0)/(t8-t0)
            let p1 = CGPoint(x: q1[0], y: q1[1]), p2 = CGPoint(x: q1[0]+q1[2]*dt, y: q1[1]+q1[3]*dt)
            let p4 = CGPoint(x: q2[0], y: q2[1]), p3 = CGPoint(x: q2[0]-q2[2]*dt, y: q2[1]-q2[3]*dt)
            
            // draw Bezier curve segment
            let segment = UIBezierPath(); segment.move(to: p1)
            segment.addCurve(to: p4, controlPoint1: p2, controlPoint2: p3)
            color.withAlphaComponent(CGFloat(0.7*alpha)).setStroke()
            segment.lineWidth = 0.04; segment.stroke()
        }
        
        // restore context
        context.restoreGState()
    }
    
    // MARK: pendulum state update
    @objc func step(link: CADisplayLink) {
        let dt = (link.targetTimestamp - link.timestamp)/32
        
        switch simulation {
        case .running:
            for _ in 0..<32 { pendulum.step(dt) }
        case .dragging:
            for _ in 0..<320 { pendulum.drag(dt/10) }
        default: break
        }
        
        trace.add(time: pendulum.time, data: pendulum.cartesian)
        setNeedsDisplay()
    }
    
    // MARK: pause simulation
    @IBAction func stop(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        switch simulation {
        case .paused:
            simulation = .running
        default:
            simulation = .paused
        }
    }
    
    // MARK: drag pendulum by the end
    @IBAction func drag(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            simulation = .dragging
        case .changed:
            let location = gesture.location(in: self)
            let scale = (4*640/528.0)/min(bounds.width, bounds.height)
            let x = Double((location.x - (bounds.minX + bounds.maxX)/2) * scale)
            let y = Double((location.y - (bounds.minY + bounds.maxY)/2) * scale)
            pendulum.target[0] =  cos(pendulum.theta0) * x - sin(pendulum.theta0) * y
            pendulum.target[1] = -sin(pendulum.theta0) * x - cos(pendulum.theta0) * y
        default:
            simulation = .running
        }
    }
}
