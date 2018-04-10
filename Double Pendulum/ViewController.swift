//
//  ViewController.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

// pendulum view controller
class ViewController: UIViewController {
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

// about page view controller
class AboutController: UIViewController {
    @IBOutlet weak var about: UITextView!
    static let blurb = Double_Pendulum.about
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure about view
        about.attributedText = AboutController.blurb
        about.adjustsFontForContentSizeCategory = true
        about.textContainerInset = UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8)
        about.scrollRangeToVisible(NSMakeRange(0, 1))
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true, completion: nil) }
}
