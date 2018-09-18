//
//  ViewController.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-07.
//  Copyright © 2018 SFU Physics Department. All rights reserved.
//

import UIKit

// MARK: pendulum view controller
class ViewController: UIViewController {
    @IBOutlet weak var pendulum: PendulumView!
    
    // controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad(); defaults(self)
        observe(UserDefaults.didChangeNotification, selector: #selector(defaults))
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    func observe(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    // user defaults
    static let dark = UIColor(white: 0.130, alpha: 1.0)
    
    static let palette = [
        UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.0), // red
        UIColor(red: 1.000, green: 0.667, blue: 0.000, alpha: 1.0), // orange
        UIColor(red: 0.500, green: 1.000, blue: 0.000, alpha: 1.0), // lime
        UIColor(red: 0.000, green: 0.500, blue: 0.125, alpha: 1.0), // green
        UIColor(red: 0.000, green: 0.850, blue: 1.000, alpha: 1.0), // cyan
        UIColor(red: 0.000, green: 0.000, blue: 0.850, alpha: 1.0), // blue
        UIColor(red: 0.425, green: 0.000, blue: 1.000, alpha: 1.0)  // violet
    ]
    
    static func defaults() {
        UserDefaults.standard.register(defaults: ["dark": false, "trace": true, "color": 0, "speed": 1, "gravity": false])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaults.standard.bool(forKey: "dark") ? .lightContent : .default
    }
    
    override var shouldAutorotate: Bool {
        return !(UserDefaults.standard.bool(forKey: "gravity"))
    }
    
    @IBAction func defaults(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let background = defaults.bool(forKey: "dark") ? ViewController.dark : UIColor.white
        pendulum.backgroundColor = background; view.backgroundColor = background
        pendulum.traceColor = ViewController.palette[defaults.integer(forKey: "color")]
        pendulum.displayTrace = defaults.bool(forKey: "trace")
        pendulum.gravity = defaults.bool(forKey: "gravity")
        
        pendulum.pendulum.l = [0.5, 0.2, 0.1][defaults.integer(forKey: "speed")]
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func settings(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func tilt(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(!defaults.bool(forKey: "gravity"), forKey: "gravity")
    }
    
    @IBAction func trace(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(!defaults.bool(forKey: "trace"), forKey: "trace")
    }
}

// MARK: about page view controller
class AboutController: UIViewController {
    @IBOutlet weak var about: UITextView!
    static let blurb = Double_Pendulum.about
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure about view
        about.isScrollEnabled = false
        about.attributedText = AboutController.blurb
        about.adjustsFontForContentSizeCategory = true
        about.textContainerInset = UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        about.isScrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true, completion: nil) }
}
