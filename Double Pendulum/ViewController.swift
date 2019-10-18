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
        UserDefaults.standard.register(defaults: ["background": 0, "color": 0, "trace": true, "speed": 1, "gravity": false])
    }
    
    var darkMode: Bool {
        switch (UserDefaults.standard.integer(forKey: "background")) {
            case 0: if #available(iOS 13.0, *) { return traitCollection.userInterfaceStyle == .dark } else { return false }
            case 1: return false
            case 2: return true
            default: return false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return darkMode ? .lightContent : .darkContent } else { return darkMode ? .lightContent : .default }
    }
    
    override var shouldAutorotate: Bool {
        return !(UserDefaults.standard.bool(forKey: "gravity"))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard #available(iOS 13.0, *) else { return }
        if let p = previousTraitCollection, p.hasDifferentColorAppearance(comparedTo: traitCollection) { restyle(self) }
    }
    
    @IBAction func restyle(_ sender: Any) {
        let background = darkMode ? ViewController.dark : UIColor.white
        pendulum.backgroundColor = background; view.backgroundColor = background
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func defaults(_ sender: Any) {
        let defaults = UserDefaults.standard; restyle(self)
        
        pendulum.traceColor = ViewController.palette[defaults.integer(forKey: "color")]
        pendulum.displayTrace = defaults.bool(forKey: "trace")
        pendulum.gravity = defaults.bool(forKey: "gravity")
        
        pendulum.pendulum.l = [0.5, 0.2, 0.1][defaults.integer(forKey: "speed")]
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
        
        // about page is always light
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
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
