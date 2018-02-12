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
    var state = double4(1,1,0,0)
    var omega2 = 1.0
    
    func velocities(_ y: double4) -> double2 {
        let gamma = cos(y[0]-y[1])
        let kappa = (16.0/9.0) - gamma*gamma
        let a = (2.0/3.0)*y[2] - gamma*y[3]
        let b = (8.0/3.0)*y[3] - gamma*y[2]
        
        return double2(a,b)/kappa
    }
    
    func derivatives(_ y: double4) -> double4 {
        let v = velocities(y)
        let a = -3.0 * omega2 * sin(y[0])
        let b = -1.0 * omega2 * sin(y[1])
        let w = v[0]*v[1] * sin(y[0]-y[1])
        
        return double4(v[0], v[1], a-w, b+w)
    }
    
    func energy(_ y: double4) -> Double {
        let v = velocities(y)
        let a = -3.0 * omega2 * cos(y[0])
        let b = -1.0 * omega2 * cos(y[1])
        let w = v[0]*v[1] * cos(y[0]-y[1])
        let k = (4.0*v[0]*v[0] + v[1]*v[1])/3.0
        
        return k + a + b + w
    }
    
    mutating func step(_ dt: Double) {
        state = gl8(state: state, step: dt, derivatives: derivatives)
    }
}
