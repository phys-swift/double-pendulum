//
//  PendulumView.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

@IBDesignable class PendulumView: UIView {
    // MARK: physical model
    var pendulum = DoublePendulum()
    var trace = History(size: 50, step: UIScreen.main.maximumFramesPerSecond/10)
    
    // MARK: pendulum trace
    var displayTrace = true { didSet {
        guard displayTrace != oldValue else { return }
        if displayTrace { trace.reset() }
    } }
    
    var showArms = true { didSet {
        guard showArms != oldValue else { return }
        if showArms { trace.reset() }
    } }
    
    var traceColor = UIColor.red
    var gradient = false

    // MARK: simulation states
    enum State: Int { case running, braking, dragging, paused }
    
    var simulation = State.running { didSet {
        guard simulation != oldValue else { return }
        link?.isPaused = (simulation == .paused)
        
        if (simulation == .braking || simulation == .dragging) {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    } }
    
    // MARK: view controller interface
    var phi: Float {
        get { return Float(pendulum.phi) }
        set { pendulum.phi = Double(newValue); trace.reset() }
    }
    
    var psi: Float {
        get { return Float(pendulum.psi) }
        set { pendulum.psi = Double(newValue); trace.reset() }
    }
    
    // MARK: accelerometer access
    var gravity = false { didSet {
        guard gravity != oldValue else { return }
        guard AppDelegate.motion.isDeviceMotionAvailable else { gravity = false; return }
        
        if gravity { AppDelegate.motion.startDeviceMotionUpdates() }
        else { AppDelegate.motion.stopDeviceMotionUpdates(); pendulum.theta = 0.0; pendulum.g = 1.0 }
    } }
    
    // MARK: link to display refresh rate timer
    var link: CADisplayLink? = nil { didSet {
        guard link != oldValue else { return }
        if let link = oldValue { link.invalidate() }
        if let link = link { link.add(to: .current, forMode: RunLoop.Mode.default) }
    } }
    
    // MARK: gesture recognizers
    var pause = UITapGestureRecognizer()
    var brake = UITapGestureRecognizer()
    var press = UILongPressGestureRecognizer()
    var swipe = [UISwipeGestureRecognizer]()
    
    // MARK: clean up
    deinit { gravity = false; link = nil }
    
    // MARK: runtime initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // activate display link
        let link = CADisplayLink(target: self, selector: #selector(step))
        link.preferredFramesPerSecond = UIScreen.main.maximumFramesPerSecond
        self.link = link
        
        // add press recognizers
        press.minimumPressDuration = 0.2; press.allowableMovement = 20
        pause.numberOfTouchesRequired = 2; brake.numberOfTouchesRequired = 1
        pause.addTarget(self, action: #selector(play)); addGestureRecognizer(pause)
        brake.addTarget(self, action: #selector(stop)); addGestureRecognizer(brake)
        press.addTarget(self, action: #selector(drag)); addGestureRecognizer(press)
        
        // add swipe recognizers
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down]
        for direction in directions {
            let swipe = UISwipeGestureRecognizer()
            swipe.direction = direction; self.swipe.append(swipe)
            swipe.addTarget(self, action: #selector(kick)); addGestureRecognizer(swipe)
        }
    }
    
    let palette = [
        UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.0), // red
        UIColor(red: 1.000, green: 0.667, blue: 0.000, alpha: 1.0), // orange
        UIColor(red: 0.500, green: 1.000, blue: 0.000, alpha: 1.0), // lime
        UIColor(red: 0.000, green: 0.500, blue: 0.125, alpha: 1.0), // green
        UIColor(red: 0.000, green: 0.850, blue: 1.000, alpha: 1.0), // cyan
        UIColor(red: 0.000, green: 0.000, blue: 0.850, alpha: 1.0), // blue
        UIColor(red: 0.425, green: 0.000, blue: 1.000, alpha: 1.0)  // violet
    ]
    
    // MARK: draw double pendulum
    override func draw(_ rect: CGRect) {
        if showArms {
            StyleKit.drawDoublePendulum(frame: rect, phi: CGFloat(pendulum.phi), psi: CGFloat(pendulum.psi), upsilon: CGFloat(pendulum.upsilon), g: CGFloat(gravity ? pendulum.g : 0.0), braking: simulation == .braking)
        }
        if displayTrace { drawTrajectory(frame: rect, trace: trace) }
    }
    
    func colorFromTime(_ t: Double) -> UIColor {
        let tInt = Int(t)
        return palette.interpolate(tInt, fraction: t - Double(tInt))
    }
    
    // MARK: draw pendulum trajectory
    func drawTrajectory(frame rect: CGRect, trace: History) {
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
            let color = gradient ? colorFromTime(t1) : traceColor

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
    
    // MARK: translate fixed vector to current screen coordinates
    func orient(_ x: Double, _ y: Double) -> (x: Double, y: Double) {
        let screen = window?.screen ?? UIScreen.main
        let origin = screen.coordinateSpace.convert(CGPoint(x: 0, y: 0), from: screen.fixedCoordinateSpace)
        let vector = screen.coordinateSpace.convert(CGPoint(x: x, y: y), from: screen.fixedCoordinateSpace)
        
        return (Double(vector.x-origin.x), Double(vector.y-origin.y))
    }
    
    // MARK: gesture location in pendulum coordinates
    func locate(_ gesture: UIGestureRecognizer) -> (x: Double, y: Double) {
        let location = gesture.location(in: self)
        let scale = (4*640/528.0)/min(bounds.width, bounds.height)
        let x = Double((location.x - bounds.midX) * scale)
        let y = Double((location.y - bounds.midY) * scale)
        
        return (x,-y)
    }
    
    // MARK: pendulum state update
    @objc func step(link: CADisplayLink) {
        let dt = (link.targetTimestamp - link.timestamp)/32
        
        // update gravity vector
        if gravity, let g = AppDelegate.motion.deviceMotion?.gravity {
            let (x,y) = orient(g.x, -g.y), g2 = x*x + y*y
            let delta = (atan2(x,y) - pendulum.theta).remainder(dividingBy: 2*Double.pi)
            
            pendulum.theta += g2 * delta
            pendulum.g = sqrt(g2)
        }
        
        // update automatic braking
        if (simulation == .running && pendulum.speed > 60.0) { simulation = .braking }
        if (simulation == .braking && pendulum.energy.total < 4.0) { simulation = .running }
        
        // advance the simulation
        switch simulation {
        case .running:
            for _ in 0..<32 { pendulum.step(dt) }
        case .braking:
            for _ in 0..<32 { pendulum.slow(dt) }
        case .dragging:
            for _ in 0..<320 { pendulum.drag(dt/10) }
        default: break
        }
        
        // log the new position
        trace.add(time: pendulum.time, data: pendulum.cartesian)
        setNeedsDisplay()
    }
    
    // MARK: pause simulation
    @IBAction func play(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        let (x,y) = locate(gesture)
        guard x*x + y*y < 5 else { return }
        
        switch simulation {
        case .running:
            simulation = .paused
        case .paused:
            simulation = .running
        default: break
        }
    }
    
    // MARK: stop pendulum
    @IBAction func stop(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        let (x,y) = locate(gesture)
        guard x*x + y*y < 5 else { return }
        
        switch sqrt(pendulum.energy.kinetic) {
        case 0...5: UIImpactFeedbackGenerator(style: .light ).impactOccurred()
        case 5...9: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case 9...:  UIImpactFeedbackGenerator(style: .heavy ).impactOccurred()
        default: break
        }
        
        pendulum.stop()
    }
    
    // MARK: drag pendulum by the end
    @IBAction func drag(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            simulation = .dragging; fallthrough
        case .changed:
            let (x,y) = locate(gesture)
            pendulum.target[0] =  cos(pendulum.theta) * x + sin(pendulum.theta) * y
            pendulum.target[1] = -sin(pendulum.theta) * x + cos(pendulum.theta) * y
        default:
            simulation = .running
        }
    }
    
    // MARK: kick pendulum
    @IBAction func kick(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        let (x,y) = locate(gesture)
        
        switch (gesture.direction, x+2, y+2) {
        case (.right,_,0...1), (.left,_,3...4), (.down,0...1,_), (.up,3...4,_): pendulum.kick(0,3)
        case (.right,_,1...2), (.left,_,2...3), (.down,1...2,_), (.up,2...3,_): pendulum.kick(3,0)
        case (.left,_,0...1), (.right,_,3...4), (.up,0...1,_), (.down,3...4,_): pendulum.kick(0,-3)
        case (.left,_,1...2), (.right,_,2...3), (.up,1...2,_), (.down,2...3,_): pendulum.kick(-3,0)
        default: break
        }
    }
}

extension Array where Element : UIColor {
    func interpolate(_ i: Int, fraction: Double) -> UIColor {
        let count = self.count - 1
        let t1 = i % count
        let t2 = (t1 + 1) % count
        return self[t1].interpolate(self[t2], fraction)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    func interpolate(_ color2: UIColor, _ fraction: Double) -> UIColor {
        let c1 = self.rgba
        let c2 = color2.rgba
        let r = c1.red.interpolate(c2.red, fraction)
        let g = c1.green.interpolate(c2.green, fraction)
        let b = c1.blue.interpolate(c2.blue, fraction)
        let a = c1.alpha.interpolate(c2.alpha, fraction)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension CGFloat {
    func interpolate(_ v2: CGFloat, _ fraction: Double) -> CGFloat {
        return ((v2 - self) * CGFloat(fraction)) + self
    }
}
