//
//  GenerateStrengthViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/5/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class GenerateStrengthViewController: UIViewController, StrengthWorkoutViewControllerDelegate {
    
    
    @IBOutlet weak var workoutLocationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var chestSwitch: UISwitch!
    @IBOutlet weak var backSwitch: UISwitch!
    @IBOutlet weak var shouldersSwitch: UISwitch!
    @IBOutlet weak var coreSwitch: UISwitch!
    @IBOutlet weak var bicepsSwitch: UISwitch!
    @IBOutlet weak var tricepsSwitch: UISwitch!
    @IBOutlet weak var legsSwitch: UISwitch!
    @IBOutlet weak var totalSwitch: UISwitch!
    @IBOutlet weak var supersetSwitch: UISwitch!    //*** hid this control and label until functionality is added in version 2
    @IBOutlet weak var numberOfExercisesTextField: UITextField!
    @IBOutlet weak var numberOfExercisesStepper: UIStepper!
    
    var numberOfBodyPartsChosen = 0
    var numberOfExercisesChosen = 0;
    var workoutLocation = ""
    
    let workoutFactory = WorkoutFactory()
    let constants = Constants()
    var workoutTemp = WorkoutTemp()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "FGBackground")!)
        
        self.numberOfExercisesStepper.minimumValue = Double(self.numberOfBodyPartsChosen)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UISwitch Functions
    @IBAction func switchStateChanged(sender: UISwitch) {
        // Changes the minumim number of exercises chosen based on the number of body parts the user want to work out
        if sender.on {
            self.numberOfBodyPartsChosen++
        }
        else {
            self.numberOfBodyPartsChosen--
        }
        
        //Sets the minimum value of the stepper to either 1 or zero based on if there are any body parts chosen
        if Int(self.numberOfBodyPartsChosen) == 0 {    //if the number of exercises chosen is 0, then makes the TextField 0
            self.numberOfExercisesTextField.text = "0"
            self.numberOfExercisesStepper.maximumValue = 0
            self.numberOfExercisesStepper.minimumValue = 0
        } else  {
            if self.numberOfExercisesTextField.text == "0" {
                self.numberOfExercisesTextField.text = "1"
            }
            self.numberOfExercisesStepper.maximumValue = 10
            self.numberOfExercisesStepper.minimumValue = 1
        }
        //println("\(self.numberOfExercisesChosen)")
        
    }
    
    @IBAction func stepperChangedValue(sender: AnyObject) {
        self.numberOfExercisesTextField.text = "\(Int(self.numberOfExercisesStepper.value))"
    }
    
    //MARK: Generate Workout
    @IBAction func generateBarButtonItemPressed(sender: AnyObject) {
        var bodyParts:[String] = [] //Array to hold body part strings based on switch state
        
        if self.chestSwitch.on {
            bodyParts.append(self.constants.kChest)
        }
        if self.backSwitch.on {
            bodyParts.append(self.constants.kBack)
        }
        if self.shouldersSwitch.on {
            bodyParts.append(self.constants.kShoulders)
        }
        if self.coreSwitch.on {
            bodyParts.append(self.constants.kCore)
        }
        if self.bicepsSwitch.on {
            bodyParts.append(self.constants.kBiceps)
        }
        if self.tricepsSwitch.on {
            bodyParts.append(self.constants.kTriceps)
        }
        if self.legsSwitch.on {
            bodyParts.append(self.constants.kLegs)
        }
        if self.totalSwitch.on {
            bodyParts.append(self.constants.kTotal)
        }
        
        // set the Workout location based on the location segmented switch
        if self.workoutLocationSegmentedControl.selectedSegmentIndex == 0 {
            self.workoutLocation = self.constants.kGym
        } else {
            self.workoutLocation = self.constants.kHome
        }
        
        // Set the number of exercises based on the value in the TextField
        self.numberOfExercisesChosen = self.numberOfExercisesTextField.text.toInt()!
        
        // Generate the strength workout
        var isNumberOfExercisesExceeded:Bool
        var returnedFromGeneratedWorkout = self.workoutFactory.generateStrengthWorkout(workoutLocation: self.workoutLocation, bodyParts: bodyParts, numberOfExercises: numberOfExercisesChosen, isSuperSet: self.supersetSwitch.on)
        isNumberOfExercisesExceeded = returnedFromGeneratedWorkout.1
        self.workoutTemp = returnedFromGeneratedWorkout.0
        
        // Moved this code to the generated workout page
//        if isNumberOfExercisesExceeded
//        {
//            var alertController = UIAlertController(title: "Note", message: "The amount of desired exercises for certain body parts exceeds what is available. Generating based on max availablity", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
        
        self.performSegueWithIdentifier("generatedToStrength", sender: isNumberOfExercisesExceeded)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "generatedToStrength"
        {
            let strengthVC = segue.destinationViewController as! StrengthWorkoutViewController
            strengthVC.workout = self.workoutTemp
            strengthVC.isNumberOfExercisesExceeded = sender as! Bool
            strengthVC.delegate = self
        }
    }
    
    //MARK: StrengthWorkoutViewControllerDelegate Methods
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismissVC() {
        //only used for going back multiple VCs
    }
    
    func passBackEditedWorkout(workout: Workout) {  //not needed in this VC
        
    }
}
