//
//  SavedHIITWorkoutViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/25/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit
protocol SavedHIITWorkoutViewControllerDelegate {
    func dismissVC()
}

class SavedHIITWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExecuteHIITViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutDetailsLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var timeCompletedLabel: UILabel!
    @IBOutlet weak var doWorkoutButton: UIBarButtonItem!
    
    var delegate:SavedHIITWorkoutViewControllerDelegate?
    
    var workout:Workout!
    var exercises:[WorkoutExercise] = []
    var workoutFactory = WorkoutFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.workout!.isAFAP {
            exercises = self.workout.hiitAFAPDict.objectForKey(kExercises) as! Array
            self.workoutDetailsLabel.text = "\(self.workout.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int) Rounds. Complete as fast as possible\n\(workout.roundsCompleted) of \(self.workout.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int) Rounds Completed"
        }
        else {
            exercises = self.workout.hiitAMREPDict.objectForKey(kExercises) as! Array
            self.workoutDetailsLabel.text = "As many rounds as possible in \(self.workout.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int) minutes"
        }
        self.notesLabel.text = self.workout.notes
        if self.workout.isComplete {
            self.timeCompletedLabel.text = "Time Completed: \(self.workout.timeCompleted)"
        }
        else {
            self.timeCompletedLabel.text = "Workout has not been performed"
        }
        
        if self.workout.isComplete {
            self.doWorkoutButton.title = "Do Workout Again?"
        }
        
        self.navigationController?.title = self.workout.name
        
    }
    
    //MARK: Segue functions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "savedHIITToExecute" {
            let executeVC = segue.destinationViewController as! ExecuteHIITViewController
            let workoutTemp = self.workoutFactory.returnWorkoutTempFromWorkout(self.workout)
            executeVC.workoutTemp = workoutTemp
            executeVC.delegate = self
            if self.workout.isComplete {
                executeVC.copiedWorkout = true
            }
            else {
                executeVC.copiedWorkout = false
            }
        }
    }
    
    //MARK: IBAction functions
    
    @IBAction func doWorkoutButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("savedHIITToExecute", sender: nil)
    }
    
    //MARK: ExecuteHIITVC delegate functions
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(false)
        if !self.workout.isComplete {
            self.workoutFactory.deleteWorkout(workout: self.workout)
        }
        if self.delegate != nil {
            self.delegate!.dismissVC()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("savedHIITCell") as! UITableViewCell
        //cell.textLabel?.text = "Name"
        cell.textLabel?.text = exercises[indexPath.row].name
        cell.detailTextLabel?.text = "\(exercises[indexPath.row].reps[0]) Reps"
        return cell
    }
    
}
