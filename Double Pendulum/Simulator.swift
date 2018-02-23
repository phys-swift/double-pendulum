//
//  Simulator.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-11.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import Foundation
import simd

// 8th order implicit Gauss-Legendre integrator (symplectic for Hamiltonian systems and A-stable)
func gl8(state y: double4, step dt: Double, derivatives f: (double4) -> double4) -> double4 {
    // Butcher tableau for 8th order Gauss-Legendre method [Butcher, Math. Comp. 18, 50 (1964)]
    let a = double4x4(
            double4( 0.869637112843634643432659873054998518E-1, -0.266041800849987933133851304769531093E-1,
                     0.126274626894047245150568805746180936E-1, -0.355514968579568315691098184956958860E-2),
            double4( 0.188118117499868071650685545087171160E0,   0.163036288715636535656734012694500148E0,
                    -0.278804286024708952241511064189974107E-1,  0.673550059453815551539866908570375889E-2),
            double4( 0.167191921974188773171133305525295945E0,   0.353953006033743966537619131807997707E0,
                     0.163036288715636535656734012694500148E0,  -0.141906949311411429641535704761714564E-1),
            double4( 0.177482572254522611843442956460569292E0,   0.313445114741868346798411144814382203E0,
                     0.352676757516271864626853155865953406E0,   0.869637112843634643432659873054998518E-1))
    let b = double4( 0.173927422568726928686531974610999704E0,   0.326072577431273071313468025389000296E0,
                     0.326072577431273071313468025389000296E0,   0.173927422568726928686531974610999704E0)
    var g = double4x4(0)
    
    // iterate trial steps
    for _ in 0..<16 { g = g*a; for i in 0..<4 { g[i] = f(y + g[i]*dt) } }
    
    // return the solution
    return y + (g*b)*dt
}

// physical model of the double pendulum
struct DoublePendulum {
    // MARK: dynamical variables
    var state = double4(2,1,0,0)
    var target = double2(0)
    
    // MARK: pendulum parameters
    var omega2 = 6.0
    var gamma = 1.0
    var theta = 0.0
    
    // MARK: simulation time
    var time = 0.0
    
    // MARK: interface to controls
    var phi: Double {
        get { return (180.0/Double.pi) * state[0] }
        set {
            let delta = (Double.pi/180.0) * (newValue - phi)
            state[0] += delta; state[1] += delta
            state[2] = 0.0; state[3] = 0.0
        }
    }
    
    var psi: Double {
        get { return (180.0/Double.pi) * (state[1] - state[0]) }
        set {
            let delta = (Double.pi/180.0) * (newValue - psi)
            let v = velocities(state); state[1] += delta
            
            let sigma = cos(state[0]-state[1])
            state[2] = ((8.0/3.0) + sigma) * v[0]
            state[3] = ((2.0/3.0) + sigma) * v[0]
        }
    }
    
    var upsilon: Double {
        get { return (180.0/Double.pi) * theta }
        set {
            let delta = (Double.pi/180.0) * (newValue - upsilon)
            theta += delta; state[0] -= delta; state[1] -= delta
        }
    }
    
    var g: Double {
        get { return omega2/6.0 }
        set { omega2 = 6.0*newValue }
    }
    
    // MARK: cartesian coordinates of the end
    var cartesian: double4 {
        let v = velocities(state)
        let s1 = sin(state[0]+theta), s2 = sin(state[1]+theta)
        let c1 = cos(state[0]+theta), c2 = cos(state[1]+theta)
        
        return double4(s1+s2,-c1-c2,v[0]*c1+v[1]*c2,v[0]*s1+v[1]*s2)
    }
    
    // MARK: equations of motion
    func velocities(_ y: double4) -> double2 {
        let sigma = cos(y[0]-y[1])
        let kappa = (16.0/9.0) - sigma*sigma
        let a = (2.0/3.0)*y[2] - sigma*y[3]
        let b = (8.0/3.0)*y[3] - sigma*y[2]
        
        return double2(a,b)/kappa
    }
    
    func derivatives(_ y: double4) -> double4 {
        let v = velocities(y)
        let a = -3.0 * omega2 * sin(y[0])
        let b = -1.0 * omega2 * sin(y[1])
        let w = v[0]*v[1] * sin(y[0]-y[1])
        
        return double4(v[0], v[1], a-w, b+w)
    }
    
    func dissipative(_ y: double4) -> double4 {
        let v = velocities(y), sigma = cos(y[0]-y[1])
        let a = -3.0 * omega2 * sin(y[0]) - (2.0*v[0] + v[1]*sigma) * gamma
        let b = -1.0 * omega2 * sin(y[1]) - (1.0*v[1] + v[0]*sigma) * gamma
        let w = v[0]*v[1] * sin(y[0]-y[1])
        
        return double4(v[0], v[1], a-w, b+w)
    }
    
    // MARK: dragging motion
    func dragging(_ y: double4) -> double4 {
        let v = velocities(y), omega2 = 1600.0, gamma = 4.0 * sqrt(omega2), sigma = cos(y[0]-y[1])
        let a = (target[0]*cos(y[0]) + target[1]*sin(y[0])) * omega2 - (v[0] + v[1]*sigma) * gamma
        let b = (target[0]*cos(y[1]) + target[1]*sin(y[1])) * omega2 - (v[1] + v[0]*sigma) * gamma
        let w = (v[0]*v[1] - omega2) * sin(y[0]-y[1])
        
        return double4(v[0], v[1], a-w, b+w)
    }
    
    // MARK: pendulum energy
    var energy: (kinetic: Double, potential: Double, total: Double) {
        let v = velocities(state)
        let a = -3.0 * omega2 * cos(state[0])
        let b = -1.0 * omega2 * cos(state[1])
        let w = v[0]*v[1] * cos(state[0]-state[1])
        let k = (4.0*v[0]*v[0] + v[1]*v[1])/3.0
        
        return (k+w, a+b, k+a+b+w)
    }
    
    // MARK: perceptual speed of motion
    var speed: Double { let v = velocities(state); return sqrt(2.0*v[0]*(v[0]+v[1]) + v[1]*v[1]) }
    
    // MARK: timescale to be resolved
    var timescale: Double { return (2.0*Double.pi)/sqrt(13.0*omega2 + 3.0*energy.total) }
    
    // MARK: pendulum evolution
    mutating func step(_ dt: Double) {
        state = gl8(state: state, step: dt, derivatives: derivatives); time += dt
    }
    
    mutating func slow(_ dt: Double) {
        state = gl8(state: state, step: dt, derivatives: dissipative); time += dt
    }
    
    // MARK: drag the pendulum
    mutating func drag(_ dt: Double) {
        state = gl8(state: state, step: dt, derivatives: dragging); time += dt
    }
    
    // MARK: kick the pendulum
    mutating func kick(_ v1: Double, _ v2: Double) {
        let sigma = cos(state[0]-state[1])
        state[2] += (8.0/3.0) * v1 + sigma * v2
        state[3] += (2.0/3.0) * v2 + sigma * v1
    }
    
    // MARK: stop the pendulum
    mutating func stop() { state[2] = 0.0; state[3] = 0.0 }
}

// pendulum trajectory is stored in a ring buffer
struct History {
    // MARK: data types used
    typealias Time = Double
    typealias Data = double4
    typealias Element = (time: Time, data: Data)
    
    // MARK: buffer variables
    var time: [Time]
    var data: [Data]
    
    // MARK: buffer parameters
    let size: Int
    let step: Int
    var head = 0
    var tail = 0
    
    // MARK: buffer properties
    var count: Int { return (head-tail+step-1)/step }
    var full: Bool { return count >= size }
    
    // MARK: default initializer
    init(size count: Int, step every: Int = 1) {
        size = count; step = every
        time = [Time](repeating: 0, count: count)
        data = [Data](repeating: Data(0), count: count)
    }
    
    // MARK: access to buffer contents, tail to head
    subscript (index: Int) -> Element {
        get { let i = (tail/step + index) % size; return (time[i], data[i]) }
        set { let i = (tail/step + index) % size; time[i] = newValue.time; data[i] = newValue.data }
    }
    
    // MARK: log new data point, dropping the tail if necessary
    mutating func add(time t: Time, data x: Data) {
        let i = (head/step) % size; time[i] = t; data[i] = x; if full { tail += 1 }; head += 1
    }
    
    // MARK: drop a point or reset the buffer entirely
    mutating func drop() { if (tail < head) { tail += 1 } }
    mutating func reset() { tail = head }
}
