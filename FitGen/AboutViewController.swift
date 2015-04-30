//
//  AboutViewController.swift
//  FitGen
//
//  Created by David Sanders on 4/16/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        let email = "fitgenapp@gmail.com"
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
        println("email button pressed")
    }

}
