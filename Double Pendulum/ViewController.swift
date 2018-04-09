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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        about.attributedText = Double_Pendulum.about
        about.adjustsFontForContentSizeCategory = true
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true, completion: nil) }
}
