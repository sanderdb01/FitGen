//
//  StartScreenViewController.swift
//  FitGen
//
//  Created by David Sanders on 12/1/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    var exerciseFactory = ExerciseFactory()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //load the database
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "FGBackground")!)
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(kWorkoutIDKey) == nil {
            defaults.setObject(0, forKey: kWorkoutIDKey)
        }
        
        if defaults.objectForKey(kMyDetailsChoice) == nil {
            defaults.setObject(kMyDate, forKey: kMyDetailsChoice)
        }
        
        if defaults.objectForKey(kTimeLimit) == nil {
            defaults.setObject(-1, forKey: kTimeLimit)
        }
        
        if defaults.objectForKey(kRoundStopTime) == nil {
            defaults.setObject(false, forKey: kRoundStopTime)
        }
        
        if defaults.objectForKey(kUnits) == nil {
            defaults.setObject(kStandard, forKey: kUnits)
            println("units set \(defaults.objectForKey(kUnits))")
        }
        println("\(defaults.objectForKey(kUnits)!)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startToGenerateHIIT"
        {
            let GenerateHIITVC = segue.destinationViewController as! GenerateHIITViewController
        }
        else if segue.identifier == "startToGenerateStrength"
        {
            let GenerateHIITVC = segue.destinationViewController as! GenerateStrengthViewController
        }
        else if segue.identifier == "startToExerciseList"
        {
            
        }
        else if segue.identifier == "startToWorkoutList"
        {
            
        }
        else if segue.identifier == "toSettingsSegue"
        {
            let settingsVC = segue.destinationViewController as! SettingsViewController
        }
    }
    
    //MARK: IBAction Functions
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        //For now, it will just reset the exercise list to default. Will eventually segue to settings page
        
        //self.exerciseFactory.loadDefaultExercises()
        performSegueWithIdentifier("toSettingsSegue", sender: nil)
    }

    @IBAction func strengthButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("startToGenerateStrength", sender: nil)
    }
    
    @IBAction func hiitButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("startToGenerateHIIT", sender: nil)
    }

    @IBAction func cardioCoreButtonTapped(sender: UIButton) {
    }
    
    @IBAction func exerciseListButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("startToExerciseList", sender: nil)
    }
    @IBAction func profileButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("startToWorkoutList", sender: nil)
    }
    
}
