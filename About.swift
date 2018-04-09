//
//  About.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-04-08.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

let blurb: String = """

Double pendulum is a simple mechanical system displaying chaos.
"""

let about: NSAttributedString = {
    let body: [NSAttributedStringKey: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .body)
    ]
    
    let about = NSMutableAttributedString(string: blurb, attributes: body)
    
    return NSAttributedString(attributedString: about)
}()
