//
//  HowToViewController.swift
//  FitGen
//
//  Created by David Sanders on 4/15/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {
    //*** hid the "Watch Video" Button until I add functionality
    
    @IBOutlet weak var textView: UITextView!
    
    var exerciseWE:WorkoutExercise?
    var exerciseDE:DefaultExercise?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.exerciseWE != nil {
            //*** String from the plist is exactly as it is written, automatically adding the escape characters. So, \n becomes \\n. Need to get rid of it
            self.textView.text = self.exerciseWE!.howTo.stringByReplacingOccurrencesOfString("\\n\\n", withString: "\n\n", options: nil, range: nil)
            println("loaded ok")
            
        } else {
            println("not loaded ok")
        }
        
        self.textView.textColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func viewVideoButtonPressed(sender: AnyObject) {
    }
    
    
}
