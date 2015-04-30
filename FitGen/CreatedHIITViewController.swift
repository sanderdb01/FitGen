//
//  CreatedHIITViewController.swift
//  FitGen
//
//  Created by David Sanders on 11/30/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit
import CoreData

protocol CreatedHIITViewControllerDelegate {
    func dismissVC()
}

class CreatedHIITViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChangeHIITExerciseTableViewControllerDelegate, ExecuteHIITViewControllerDelegate {
    
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var workoutDetailsLabel: UILabel!
    
    
    var exerciseFactory = ExerciseFactory()
    var workoutFactory:WorkoutFactory = WorkoutFactory()
    let constants = Constants()
    var workoutTemp:WorkoutTemp?    //workout that will eventually be saved. Until saved, it constantly gets updated with the newest data
    var exercises:[WorkoutExercise] = []
    var delegate:CreatedHIITViewControllerDelegate?
    
    var workoutLocation: String = ""
    var generalBodyLocation: String = ""
    var difficultyLevel: Int = 0
    var isAFAP: Bool = false
    var numberOfRounds = 0
    var isCardioCore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        // set the tableview delegate and datasource to self
        self.exerciseTableView.delegate = self
        self.exerciseTableView.dataSource = self
        
        if self.workoutTemp == nil {    // Executes only if a workout has not been previously created
            // create a workoutTemp object.
            self.workoutTemp = workoutFactory.generateHIITWorkout(workoutLocation: self.workoutLocation, generalBodyLocation: self.generalBodyLocation, difficultyLevel: self.difficultyLevel, isAFAP: self.isAFAP, isCardioCore: self.isCardioCore)
            self.numberOfRounds = self.workoutTemp!.numberOfRounds.integerValue
            
            //  Determine if it is a AFAP or AMRAP. Set the workoutDetailsLabel text with the rounds or time
            if self.isAFAP {
                exercises = self.workoutTemp!.hiitAFAPDict.objectForKey(constants.kExercises) as! Array
                self.workoutDetailsLabel.text = "\(self.workoutTemp!.hiitAFAPDict.objectForKey(constants.kNumberOfRounds) as! Int) Rounds. Complete as fast as possible"
            }
            else {
                exercises = self.workoutTemp!.hiitAMREPDict.objectForKey(constants.kExercises) as! Array
                self.workoutDetailsLabel.text = "As many rounds as possible in \(self.workoutTemp!.hiitAMREPDict.objectForKey(constants.kTimeForAMRAP) as! Int) minutes"
            }
        }
        
        // reload the tableView
        self.exerciseTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: IBAction functions
    
    // Save the workout
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        var alertController = UIAlertController(title: "Enter Name", message: "Add a name for the workout", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "WORKOUT NAME"
            textField.text = "HIIT \(Date.toString(date: Date.getCurrentDate()))"
            textField.clearButtonMode = UITextFieldViewMode.Always
        }
        
        let textField = alertController.textFields![0] as! UITextField
        
        // Add the action to save the workout in CoreData using the WorkoutFactory Class, passing the workoutTemp object as the parameter
        let saveWorkoutAction = UIAlertAction(title: "Save Workout", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            var name = textField.text
            self.workoutTemp!.name = name
            self.workoutTemp!.roundsCompleted = 0
            let defaults = NSUserDefaults.standardUserDefaults()
            var workoutID = defaults.objectForKey(kWorkoutIDKey) as! Int
            workoutID++
            self.workoutFactory.saveWorkoutToCoreData(self.workoutTemp!, workoutID: workoutID, isCompleted: false)
            defaults.setObject(workoutID, forKey: kWorkoutIDKey)
        }
        alertController.addAction(saveWorkoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func executeWorkoutButtonTapped(sender: UIButton) {
        
        self.performSegueWithIdentifier("hiitToExecute", sender: nil)
    }
    
    //MARK: ChangeHIITExerciseTableViewControllerDelegate functions
    
    func passBackExerise(exercise: DefaultExercise, indexPath:NSIndexPath) {
        
        var reps:[Int] = []
        var weight:[Int] = []
        
        weight.append(Int(exercise.weight))
        
        switch self.difficultyLevel
        {
        case 1:
            reps.append(Int(exercise.level1Reps) / self.numberOfRounds)
        case 2:
            reps.append(Int(exercise.level2Reps) / self.numberOfRounds)
        case 3:
            reps.append(Int(exercise.level3Reps) / self.numberOfRounds)
        case 4:
            reps.append(Int(exercise.level4Reps) / self.numberOfRounds)
        default:
            reps.append(0)
        }
        var ex:WorkoutExercise = WorkoutExercise(name: exercise.name, date: Date.getCurrentDate(), workoutType: exercise.workoutType, specificBodyLocation: exercise.specificBodyLocation, generalBodyLocation: exercise.generalBodyLocation, superset: 0, weight: weight, reps: reps, howTo: exercise.howTo)
        
        if self.isAFAP {
            self.exercises.removeAtIndex(indexPath.row)
            self.exercises.insert(ex, atIndex: indexPath.row)
            self.workoutTemp!.hiitAFAPDict = [constants.kExercises: self.exercises, constants.kNumberOfRounds: self.numberOfRounds]
        }
        else {
            self.exercises.removeAtIndex(indexPath.row)
            self.exercises.insert(ex, atIndex: indexPath.row)
            self.workoutTemp!.hiitAMREPDict = [constants.kExercises: self.exercises, constants.kTimeForAMRAP: self.workoutTemp!.hiitAMREPDict.objectForKey(constants.kTimeForAMRAP) as! Int]
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
        self.exerciseTableView.reloadData()
    }
    
    //MARK: ExecuteHIITViewControllerDelegate Functions
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(false)
        self.delegate!.dismissVC()
    }
    
    //MARK: Segue function
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hiitToExerciseChange" {
            var changeHIITExVC = segue.destinationViewController as! ChangeHIITExerciseTableViewController
            changeHIITExVC.previousVCIndexPath = sender as! NSIndexPath
            changeHIITExVC.delegate = self
            changeHIITExVC.exercise = self.exercises[(sender as! NSIndexPath).row]
        }
        else if segue.identifier == "hiitToExecute" {
            var executeHIITVC = segue.destinationViewController as! ExecuteHIITViewController
            executeHIITVC.delegate = self
            executeHIITVC.workoutTemp = self.workoutTemp
            
        }
        else if segue.identifier == "hiitCreatedToDetail" {
            var detailVC = segue.destinationViewController as! HIITExerciseDetailViewController
            detailVC.exercise = sender as? WorkoutExercise
            
        }
    }
    
    //MARK: Relaod all data
    func reloadData() {
        if self.isAFAP {
            self.workoutTemp!.hiitAFAPDict = [constants.kExercises: self.exercises, constants.kNumberOfRounds: self.numberOfRounds]
        }
        else {
            self.workoutTemp!.hiitAMREPDict = [constants.kExercises: self.exercises, constants.kTimeForAMRAP: self.workoutTemp!.hiitAMREPDict.objectForKey(constants.kTimeForAMRAP) as! Int]
        }
        self.exerciseTableView.reloadData()
    }
    
    // UITableView Data Source Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:HIITTableViewCell = tableView.dequeueReusableCellWithIdentifier("hiitCell") as! HIITTableViewCell
        cell.nameLabel.text = exercises[indexPath.row].name
//        cell.detailsLabel.text = "Body Location: \(exercises[indexPath.row].generalBodyLocation), Weight: \(exercises[indexPath.row].weight[0])"
        
        cell.detailsLabel.text = "Weight: \(exercises[indexPath.row].weight[0])"
        let defaults = NSUserDefaults.standardUserDefaults()
        let weight = exercises[indexPath.row].weight[0] as! Int
        //*** code to convert weight units
        //cell.detailsLabel.text = (defaults.objectForKey(kUnits) as! String == kMetric) ? ConvertUnits.poundsToKilograms(weight) : "\(weight)"
        var repsUnit = ""
        var reps = "\(exercises[indexPath.row].reps[0] as! Int)"
        switch exercises[indexPath.row].name {
            case "running":
            //repsUnit = " m"
            reps = (defaults.objectForKey(kUnits) as! String == kMetric) ? "\(reps) \(kMeterUnits)" : "\(ConvertUnits.metersToMiles(reps.toInt()!)) \(kMileUnits)"
            case "planks":
            repsUnit = " sec"
        default:
            repsUnit = ""
        }
        //cell.repsLabel.text = "\(exercises[indexPath.row].reps[0]) \(repsUnit)"
        cell.repsLabel.text = "\(reps) \(repsUnit)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var alertController = UIAlertController(title: "Exercise Options", message: "Choose an Option", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "WEIGHT"
            textField.text = "\(self.exercises[indexPath.row].weight[0])"
            textField.clearButtonMode = UITextFieldViewMode.Always
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        let textField = alertController.textFields![0] as! UITextField
        
        alertController.addAction(UIAlertAction(title: "Change Weight", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            var weight:[Int] = self.exercises[indexPath.row].weight as! Array
            //Long code to convert units if needed
            //weight[0] = (defaults.objectForKey(kUnits) as! String == kMetric) ? ConvertUnits.kilogramsToPounds(Double(textField.text.toInt()!)).toInt()! : textField.text.toInt()!
            weight[0] = textField.text.toInt()!
            self.exercises[indexPath.row].weight = weight
            self.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Exercise", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("hiitToExerciseChange", sender: indexPath)  //Segue to replace the exerise with another similar exercise
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("hiitCreatedToDetail", sender: self.exercises[indexPath.row])
        println("\(indexPath.row)")
    }
}
