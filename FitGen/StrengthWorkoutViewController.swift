//
//  StrengthWorkoutViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/8/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

protocol StrengthWorkoutViewControllerDelegate {
    func dismissViewController()
    func passBackEditedWorkout(workout:Workout)
    func dismissVC()
}

class StrengthWorkoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StrengthExerciseDetailViewControllerDelegate, AddExerciseToStrengthTableViewControllerDelegate, WorkoutNotesViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    var workout:WorkoutTemp = WorkoutTemp() //this is for creating a new workout
    var editWorkout:Workout? //This is for editing an existing workout
    var exerciseArray:[WorkoutExercise] = []
    var workoutFactory:WorkoutFactory = WorkoutFactory()
    var selectedRow:Int = 0
    var selectedExerise:WorkoutExercise!
    var isNumberOfExercisesExceeded:Bool = false
    var copiedWorkout:Bool = false
    
    var delegate:StrengthWorkoutViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // If the passed value for isNumberOfExercisesExceeded is true (not enough exercises), then show message. 
        if isNumberOfExercisesExceeded
        {
            var alertController = UIAlertController(title: "Note", message: "The amount of desired exercises for certain body parts exceeds what is available. Generating based on max availablity", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        isNumberOfExercisesExceeded = false

        if (editWorkout != nil) {   //Executes if editWorkout it not nil. That would mean that the sender was from the SavedWorkoutVC, and we are modifiying an existing workout from the saved page
            self.workout = workoutFactory.returnWorkoutTempFromWorkout(self.editWorkout!)
        }
        
        self.exerciseArray = self.workout.strengthArray as! Array
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.exerciseArray = self.workout.strengthArray as Array
        self.workout.strengthArray = self.exerciseArray
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "strengthToDetail" {
            var detailVC:StrengthExerciseDetailViewController = segue.destinationViewController as! StrengthExerciseDetailViewController
            detailVC.delegate = self
            detailVC.indexPath = sender as! NSIndexPath
            detailVC.exercise = exerciseArray[(sender as! NSIndexPath).row] as WorkoutExercise
        }
        if segue.identifier == "strengthToAdd" {
            var addExVC = segue.destinationViewController as! AddExerciseToStrengthTableViewController
            addExVC.delegate = self
            
        }
    }
    
    //MARK: Bar Button Pressed Methods
    
    @IBAction func saveBarButtonPressed(sender: AnyObject) {
        
        if self.editWorkout != nil {   //Executes if editWorkout it not nil. That would mean that the sender was from the SavedWorkoutVC, and we are modifiying an existing workout from the saved page
            var alertController = UIAlertController(title: "Saved", message: "\(self.workout.name) has been updated and saved", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                var workoutID = defaults.objectForKey(kWorkoutIDKey) as! Int
                workoutID++
                var updatedWorkout:Workout = self.workoutFactory.saveWorkoutToCoreData(self.workout, workoutID: workoutID, isCompleted: true)
                defaults.setObject(workoutID, forKey: kWorkoutIDKey)
                self.workoutFactory.deleteWorkout(workout: self.editWorkout!)
                
                self.delegate?.passBackEditedWorkout(updatedWorkout)
                self.delegate?.dismissViewController()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else {
        //***** When the button is tapped, a message box comes up with the option to add a name for the workout
        var alertController = UIAlertController(title: "Save Workout", message: "Enter name and save workout.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (nameTextField) in
            var name = (self.copiedWorkout ? self.workout.name : "Strength \(Date.toString(date: Date.getCurrentDate()))")    //checks if the workout is a copy
            nameTextField.placeholder = "WORKOUT NAME"
            nameTextField.text = name
            nameTextField.clearButtonMode = UITextFieldViewMode.Always
            
        }
        
        let nameTextField = alertController.textFields![0] as! UITextField
        
        // check to make sure that there is a name in the textField. Save the workout to CoreData
        let saveWorkoutAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            if nameTextField.text == "" {
                nameTextField.text = "Strength \(Date.toString(date: Date.getCurrentDate()))"
            }
            
            self.workout.name = nameTextField.text
            var workoutID = 0
            let defaults = NSUserDefaults.standardUserDefaults()
            if !self.copiedWorkout {
                workoutID = defaults.objectForKey(kWorkoutIDKey) as! Int
                workoutID++
            }
            else {
                workoutID = self.workout.workoutID
            }
            self.workoutFactory.saveWorkoutToCoreData(self.workout, workoutID: workoutID, isCompleted: true)
            defaults.setObject(workoutID, forKey: kWorkoutIDKey)
            if self.copiedWorkout {
                self.delegate?.dismissVC()
            }
            else {
                self.delegate?.dismissViewController()
            }
            
        }
        alertController.addAction(saveWorkoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBarButtonPressed(sender: AnyObject) {
        if self.tableView.editing == true {
            self.tableView.editing = false
            self.editBarButtonItem.title = "Edit"
        } else {
        self.tableView.editing = true
            self.editBarButtonItem.title = "Done"
        }
    }
    
    // Segue to VC to add a new exercise
    @IBAction func addExerciseBarButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("strengthToAdd", sender: nil)
    }
    
    @IBAction func notesBarButtonItemPressed(sender: AnyObject){
        let notesVC = self.storyboard?.instantiateViewControllerWithIdentifier("workoutNotes") as! WorkoutNotesViewController
        notesVC.delegate = self
        notesVC.notes = self.workout.notes
        notesVC.isEdit = true
        self.showViewController(notesVC, sender: nil)
    }
    
    
    //MARK: StrengthExerciseDetailViewControllerDelegate Methods (Edit exercise)
    
    // from the StrengthExerciseDetailViewController, passes back an exercise that was edited, and updates the current exercise witht he new reps and weight
    func passEditedExercise(#reps: [Int], weight: [Int], indexPath: NSIndexPath) {
        var exercise = self.exerciseArray[indexPath.row] as WorkoutExercise
        exercise.reps = reps
        exercise.weight = weight
        self.exerciseArray[indexPath.row] = exercise
        self.navigationController?.popViewControllerAnimated(true)
        self.tableView.reloadData()
    }
    
    func cancelEdit() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: AddExerciseToStrengthTableViewController Delegate Methods (add a new exercise)
    func passBackExercise(exercise: WorkoutExercise) {
        self.exerciseArray.append(exercise)
        self.navigationController?.popViewControllerAnimated(true)
        //self.tableView.reloadData()
    }
    
    //MARK: WorkoutNotesViewControllerDelegate functions
    func saveNotes(notes: String) {
        self.workout.notes = notes
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //MARK: TableView delegate and data source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("strengthCell") as! UITableViewCell
        cell.textLabel?.text = (exerciseArray[indexPath.row] as WorkoutExercise).name
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(22.0)
        var reps:[Int] = ((exerciseArray[indexPath.row] as WorkoutExercise).reps as! Array)
        cell.detailTextLabel?.text = "Sets: \(reps.count)"
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("strengthToDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("exerciseDetailVC") as! HIITExerciseDetailViewController
        detailVC.exercise = self.exerciseArray[indexPath.row]
        self.showViewController(detailVC, sender: self.exerciseArray[indexPath.row])
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                self.exerciseArray.removeAtIndex(indexPath.row)
                self.workout.strengthArray = self.exerciseArray
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            // remove the dragged row's model
            let ex = self.exerciseArray.removeAtIndex(sourceIndexPath.row)
            
            // insert it into the new position
            self.exerciseArray.insert(ex, atIndex: destinationIndexPath.row)
            
            self.workout.strengthArray = self.exerciseArray
    }

}
