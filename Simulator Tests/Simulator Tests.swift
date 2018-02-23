//
//  Simulator Tests.swift
//  Simulator Tests
//
//  Created by Andrei Frolov on 2018-02-11.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import XCTest
import simd

class SimulatorTests: XCTestCase {
    // setup and teardown
    override func setUp() { super.setUp() }    
    override func tearDown() { super.tearDown() }
    
    // test tolerance
    let epsilon: Double = 1.0e-14
    let delta: Double = 1.0e-2
    
    // test workload
    #if DEBUG
    let steps = 10000
    #else
    let steps = 1000000
    #endif
    
    func testHarmonicOscillator() {
        let dt: Double = 6.2831853071795864769252867665590057684/1024
        var y = double4(1, 0, 0, 0)
        
        for _ in 0...10240 { y = gl8(state: y, step: dt) { y in double4(y[1], -y[0], 0, 0) } }
        let q = y[0], p = y[1], dE = (p*p)/2.0 + (q*q)/2.0 - 0.5
        
        XCTAssertEqual(dE, 0.0, accuracy: epsilon)
        XCTAssertEqual(p,  0.0, accuracy: delta)
    }
    
    func testAnharmonicOscillator() {
        let dt: Double = 7.416298709205487673735401388781040185/1024
        var y = double4(1, 0, 0, 0)
        
        for _ in 0...10240 { y = gl8(state: y, step: dt) { y in double4(y[1], -y[0]*y[0]*y[0], 0, 0) } }
        let q = y[0], p = y[1], dE = (p*p)/2.0 + (q*q*q*q)/4.0 - 0.25
        
        XCTAssertEqual(dE, 0.0, accuracy: epsilon)
        XCTAssertEqual(p,  0.0, accuracy: delta)
    }
    
    func testDoublePendulum() {
        var pendulum = DoublePendulum()
        let dt = 0.01/sqrt(pendulum.omega2)
        let E0 = pendulum.energy.total
        
        for _ in 0...10240 { pendulum.step(dt) }
        let dE = pendulum.energy.total - E0
        
        XCTAssertEqual(dE, 0.0, accuracy: epsilon)
    }
    
    func testGL8Performance() {
        var y = double4(1, 0, 0, 0)
        let steps = self.steps, dt = 0.01
        
        self.measure { for _ in 0...steps { y = gl8(state: y, step: dt) { y in double4(y[1], -y[0]*y[0]*y[0], 0, 0) } } }
    }
    
    func testSimulatorPerformance() {
        var pendulum = DoublePendulum()
        let steps = self.steps/10, dt = 0.01
        
        self.measure { for _ in 0...steps { pendulum.step(dt) } }
    }
}
