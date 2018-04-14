//
//  About.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-04-08.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

// MARK: magic character representing attachment in attributed strings
let attachment = Character(Unicode.Scalar(NSAttachmentCharacter)!)

// MARK: plain text about blurb
let blurb: String = """
\(attachment)

The double pendulum is a simple mechanical system that displays chaos. The motion of the pendulum arms can be complex and unpredictable, with even minute changes leading to very different trajectories. This app accurately simulates the physics of a frictionless double pendulum, so you can explore and enjoy the complexity and beauty of mechanical chaos.

Interacting with the pendulum:
Tap with one finger within the circle to stop the pendulum; long-press to grab it by the end and drag it around. Swipe within the inner circle to give the first arm a kick, or within the outer circle to give the second arm a kick in the direction of the swipe. Tap with two fingers to pause or resume the simulation. If the motion of the pendulum gets too fast, emergency brakes will engage. You can control the simulation using real gravity and your device orientation if you enable it in Settings.

What exactly is being computed here?
The equations of motion for a double pendulum are derived here. They are integrated numerically using an eighth-order Gauss-Legendre method, which is highly accurate and preserves the symplectic form for Hamiltonian systems. Dragging the pendulum by the end actually solves the equations of motion of a double pendulum with a spring attached between its end and your finger. Viscous friction which is used to damp the pendulum motion while dragging and braking is modelled by Rayleigh dissipation.

Want to learn more?
This app is brought to you by the Cosmology Group at the Physics Department of the Simon Fraser University, where we teach classical and modern physics courses, as well as how to do computer simulations and write apps such as this one. Come to the Dark Side, we have cookies!

Have Fun!
"""

// MARK: attributed about blurb
let about: NSAttributedString = {
    // logo attachment
    let logo = NSTextAttachment(); logo.image = UIImage(named: "SFU")
    let w = UIScreen.main.fixedCoordinateSpace.bounds.width - 32, h = w/6.9
    logo.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: w, height: h))
    
    // paragraph styles
    let style = NSMutableParagraphStyle()
    style.paragraphSpacing = 4; let normal = style.copy()
    style.alignment = .center;  let center = style.copy()
    
    // common attributes
    let body: [NSAttributedStringKey: Any] = [
        .paragraphStyle: normal,
        .font: UIFont.preferredFont(forTextStyle: .body)
    ]
    
    let title: [NSAttributedStringKey: Any] = [
        .paragraphStyle: center,
        .font: UIFont.preferredFont(forTextStyle: .title1)
    ]
    
    let heading: [NSAttributedStringKey: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .headline)
    ]
    
    let gesture: [NSAttributedStringKey: Any] = [
        .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
    ]
    
    // attributed about text
    let about = NSMutableAttributedString(string: blurb, attributes: body)
    about.addAttribute(.attachment, value: logo, range: NSMakeRange(0,1))
    
    // dress up attributed text
    for (tag,style) in [
        "Interacting with the pendulum:": heading,
        "What exactly is being computed here?": heading,
        "Want to learn more?": heading,
        "Have Fun!": title,
        "tap": gesture,
        "long-press": gesture,
        "swipe": gesture,
        "tap with two fingers": gesture,
        "Settings": [NSAttributedStringKey.link: UIApplicationOpenSettingsURLString],
        "derived here": [NSAttributedStringKey.link: "https://en.wikipedia.org/wiki/Double_pendulum"],
        "Gauss-Legendre method": [NSAttributedStringKey.link: "https://doi.org/10.1090/S0025-5718-1964-0159424-9"],
        "symplectic form": [NSAttributedStringKey.link: "https://en.wikipedia.org/wiki/Symplectic_integrator"],
        "Hamiltonian systems": [NSAttributedStringKey.link: "https://en.wikipedia.org/wiki/Hamiltonian_mechanics"],
        "Rayleigh dissipation": [NSAttributedStringKey.link: "https://en.wikipedia.org/wiki/Lagrangian_mechanics#Extensions_to_include_non-conservative_forces"],
        "Cosmology Group": [NSAttributedStringKey.link: "http://www.sfu.ca/physics/cosmology/"],
        "Physics Department": [NSAttributedStringKey.link: "https://www.sfu.ca/physics.html"],
        "Simon Fraser University": [NSAttributedStringKey.link: "https://www.sfu.ca/"],
        "physics courses": [NSAttributedStringKey.link: "https://www.sfu.ca/physics/courses/yearly-offerings.html"]
    ] {
        guard let range = blurb.range(of: tag, options: .caseInsensitive) else { continue }
        about.addAttributes(style, range: NSMakeRange(range.lowerBound.encodedOffset, tag.count))
    }
    
    return NSAttributedString(attributedString: about)
}()
