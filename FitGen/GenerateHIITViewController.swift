//
//  GenerateHIITViewController.swift
//  FitGen
//
//  Created by David Sanders on 11/30/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class GenerateHIITViewController: UIViewController, CreatedHIITViewControllerDelegate {

    @IBOutlet weak var locationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bodySegmentedControl: UISegmentedControl!
    @IBOutlet weak var intensitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var hiitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cardioCoreSwitch: UISwitch!
    
    var constants = Constants()
    var exerciseFactory = ExerciseFactory()
    
    var workoutLocation = ""
    var generalBodyLocation = ""
    var difficultyLevel = 0
    var isAFAP = false
    var isCardioCore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //load the database
        //self.exerciseFactory.loadDefaultExercises()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueToCreated"
        {
            let createdVC = segue.destinationViewController as! CreatedHIITViewController
            createdVC.workoutLocation = self.workoutLocation
            createdVC.generalBodyLocation = self.generalBodyLocation
            createdVC.difficultyLevel = self.difficultyLevel
            createdVC.isAFAP = self.isAFAP
            createdVC.isCardioCore = self.isCardioCore
            createdVC.delegate = self
        }
    }
    
    //MARK: CreatedHIITViewControllerDelegate functions
    
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(false)
        var alertController = UIAlertController(title: "SAVED", message: "Workout has been saved", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: IBActions

    @IBAction func generateButtonTapped(sender: UIButton)
    {
        //set the correct location
        switch self.locationSegmentedControl.selectedSegmentIndex
            {
        case 0:
            self.workoutLocation = constants.kGym
        case 1:
            self.workoutLocation = constants.kHome
        default:
            println("default")
        }
        
        //set the correct general body location
        switch self.bodySegmentedControl.selectedSegmentIndex
            {
        case 0:
            self.generalBodyLocation = constants.kUpper
        case 1:
            self.generalBodyLocation = constants.kLower
        case 2:
            self.generalBodyLocation = constants.kTotal
        default:
            println("default")
        }
        
        //set the correct difficulty level
        switch self.intensitySegmentedControl.selectedSegmentIndex
            {
        case 0:
            self.difficultyLevel = 1
        case 1:
            self.difficultyLevel = 2
        case 2:
            self.difficultyLevel = 3
        case 3:
            self.difficultyLevel = 4
        default:
            println("default")
        }
        
        //set the HIIT Type
        switch self.hiitSegmentedControl.selectedSegmentIndex
            {
        case 0:
            self.isAFAP = true
        case 1:
            self.isAFAP = false
        default:
            println("default")
        }
        performSegueWithIdentifier("segueToCreated", sender: nil)
    }
    
    @IBAction func cardioCoreSwitchValueChanged(sender: AnyObject) {
        
        if self.cardioCoreSwitch.on {
            self.isCardioCore = true
        }
        else {
            self.isCardioCore = false
        }
    }
    
}
