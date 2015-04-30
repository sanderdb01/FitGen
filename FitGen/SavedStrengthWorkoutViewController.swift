//
//  SavedStrengthWorkoutViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/26/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

protocol SavedStrengthWorkoutViewControllerDelegate {
    func dismissVC()
}

class SavedStrengthWorkoutViewController: UITableViewController, WorkoutNotesViewControllerDelegate, StrengthWorkoutViewControllerDelegate {
    
    var workout:Workout?
    var exerciseArray:[WorkoutExercise] = []
    var workoutFactory:WorkoutFactory = WorkoutFactory()
    var delegate:SavedHIITWorkoutViewControllerDelegate?

    @IBOutlet weak var notesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var copyWorkoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseArray = self.workout!.strengthArray as! [WorkoutExercise]
        //let backgroundImage = UIImageView(image: UIImage(named: "FGBackground.png"))
        //self.tableView.backgroundView = backgroundImage
        self.navigationController!.title = self.workout!.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "savedStrengthToPerform" {
            var workoutTemp = workoutFactory.returnWorkoutTempFromWorkout(self.workout!)
            let strengthVC = segue.destinationViewController as! StrengthWorkoutViewController
            strengthVC.workout = workoutTemp
            strengthVC.copiedWorkout = true
            strengthVC.delegate = self
        }
    }
    
    //MARK: BarButton IBActions
    
    @IBAction func notesBarButtonItemPressed(sender: AnyObject) {
        let notesVC = self.storyboard?.instantiateViewControllerWithIdentifier("workoutNotes") as! WorkoutNotesViewController
        notesVC.delegate = self
        notesVC.notes = self.workout!.notes as String
        notesVC.isEdit = false
        self.showViewController(notesVC, sender: nil)
    }
    @IBAction func editWorkoutBarButtonItemPressed(sender: AnyObject) {
        let editWorkoutVC = self.storyboard?.instantiateViewControllerWithIdentifier("strengthWorkoutVC") as! StrengthWorkoutViewController
        editWorkoutVC.delegate = self
        editWorkoutVC.editWorkout = self.workout!
        //editWorkoutVC.workout = workoutFactory.returnWorkoutTempFromWorkout(self.workout!)
        self.showViewController(editWorkoutVC, sender: nil)
    }
    
    @IBAction func copyWorkoutButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("savedStrengthToPerform", sender: nil)
    }
    
    
    //MARK: WorkoutSavedViewControllerDelegate functions (not using currently, but needed for no errors)
    func saveNotes(notes: String) {
    }
    
    //MARK: StrengthViewControllerDelegate Methods
    func dismissViewController() {
        self.navigationController?.popViewControllerAnimated(true)
        tableView.reloadData()
    }
    
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(false)
        self.delegate?.dismissVC()
    }
    
    func passBackEditedWorkout(workout: Workout) {
        self.workout = workout
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return exerciseArray.count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let exercise:WorkoutExercise = self.exerciseArray[section]
        return exercise.name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //return self.exerciseArray.count
        let exercise:WorkoutExercise = self.exerciseArray[section]
        var reps = exercise.reps as! [Int]
        return reps.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("savedStrengthCell", forIndexPath: indexPath) as SavedStrengthTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("savedStrengthCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        let exercise:WorkoutExercise = self.exerciseArray[indexPath.section]
        var reps = exercise.reps as! [Int]
        var weight = exercise.weight as! [Int]
        cell.textLabel?.text = "Set \(indexPath.row + 1): Weight = \(weight[indexPath.row])  Reps = \(reps[indexPath.row])"
        cell.textLabel?.textColor = UIColor.whiteColor()
        
//        let exercise:WorkoutExercise = self.exerciseArray[indexPath.row]
//        var reps = exercise.reps as [Int]
//        var weight = exercise.weight as [Int]
//        //cell.nameTextLabel.text = exercise.name
//        cell.textLabel?.text = exercise.name
//        var detailsText = ""
//        var set = 0
//        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.width, 50.0)
//        tableView.rowHeight = 50.0
//        for rep in reps {
//            detailsText += "Set \(set + 1): weight = \(weight[set]) Reps = \(reps[set])\n"
//            set++
//        }
        //cell.detailsTextLabel?.text = detailsText
        

        return cell
    }


}
