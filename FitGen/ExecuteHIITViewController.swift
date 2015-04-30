//
//  ExecuteHIITViewController.swift
//  FitGen
//
//  Created by David Sanders on 2/5/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit
import AVFoundation

protocol ExecuteHIITViewControllerDelegate {
    func dismissVC()
}

class ExecuteHIITViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutNotesViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutDetailLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var setTimeLimitButton: UIBarButtonItem!
    
    var workoutTemp:WorkoutTemp?    //workout that will be executed and eventually be saved. Until saved, it constantly gets updated with the newest data
    var exercises:[WorkoutExercise] = []
    var roundsCompleted = 0
    var workoutFactory = WorkoutFactory()
    var delegate:ExecuteHIITViewControllerDelegate?
    var copiedWorkout:Bool = false  //set to true from VC caller if it is a copy of an old workout
    
    var startTime = NSTimeInterval()
    var pausedElapsedTime = NSTimeInterval()
    var timer = NSTimer()
    var elapsedTime:NSTimeInterval = NSTimeInterval()
    var pausedTimer = true
    var timeLimit = -1
    var timeLimitReached = false
    var timerStarted = false    //indicates if the timer was ever actually started. If it has, selecting the time limit is disabled
    var watchTime = "00:00"  //time string to send to the iWatch
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Set up WatchKit Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleRequest:"), name: kWatchKitDidMakeRequest, object: nil)
        
        self.reloadView()
        self.workoutTemp!.roundsCompleted = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Timer Functions
    
    func updateTimer() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //find the difference between current time and start time
        self.elapsedTime = (currentTime - startTime) + self.pausedElapsedTime
        var tempElapsedTime:NSTimeInterval = self.elapsedTime   //variable that will be subtracted out in the calculations
        
        if self.workoutTemp!.isAFAP {
            if self.timeLimit < 0 || self.timeLimit > Int(tempElapsedTime / 60.0) { //check the time limit to make sure that the time limit has not been reached or is not set
                //calculate the minutes in elapsed time
                let minutes = UInt(tempElapsedTime / 60.0)
                tempElapsedTime -= (NSTimeInterval(minutes) * 60)
                
                //calculate the seconds in elapsed time
                let seconds = UInt(tempElapsedTime)
                tempElapsedTime -= NSTimeInterval(seconds)
                
                //find out the fraction of milliseconds to be displayed
                let fraction = UInt(tempElapsedTime * 100)
                
                //find out the leading zero for minutes, seconds, and milliseconds and store them as string constants
                let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
                let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
                let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
                
                //concatenate minutes, seconds, and milliseconds and assign it to a string and label
                self.timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
                self.watchTime = "\(strMinutes):\(strSeconds)"
            } else {
                //concatenate minutes, seconds, and milliseconds and assign it to a string and label
                self.timerLabel.text = "\(self.timeLimit):00:00"
                self.watchTime = "\(self.timeLimit):00"
                self.timer.invalidate()
                self.startButton.setTitle("N/A", forState: UIControlState.Normal)
                self.timeLimitReached = true
            }
        }
        else {
            tempElapsedTime = ((self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Double) * 60) - tempElapsedTime
            let minutes = UInt(tempElapsedTime / 60.0)
            tempElapsedTime -= (NSTimeInterval(minutes) * 60)
            
            //calculate the seconds in elapsed time
            let seconds = UInt(tempElapsedTime)
            tempElapsedTime -= NSTimeInterval(seconds)
            
            //find out the fraction of milliseconds to be displayed
            let fraction = UInt(tempElapsedTime * 100)
            
            //find out the leading zero for minutes, seconds, and milliseconds and store them as string constants
            let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
            let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
            let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
            
            //concatenate minutes, seconds, and milliseconds and assign it to a string and label
            self.timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
            self.watchTime = "\(strMinutes):\(strSeconds)"
        }
        
    }
    
    //MARK: helper functions
    
    func reloadView() {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.timeLimit = defaults.objectForKey(kTimeLimit) as! Int
        
        
        //  Determine if it is a AFAP or AMRAP. Set the workoutDetailsLabel text with the rounds or time
        if self.workoutTemp!.isAFAP {
            self.exercises = self.workoutTemp!.hiitAFAPDict.objectForKey(kExercises) as! Array
            if self.timeLimit < 0 {
                self.workoutDetailLabel.text = "\(self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int) Rounds. Complete as fast as possible"
            } else {
                self.workoutDetailLabel.text = "\(self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int) Rounds. Complete as fast as possible. \(self.timeLimit)min Time Limit"
            }
            self.roundLabel.text = "Round \(self.roundsCompleted) of \(self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int)"
        }
        else {
            self.exercises = self.workoutTemp!.hiitAMREPDict.objectForKey(kExercises) as! Array
            self.workoutDetailLabel.text = "As many rounds as possible in \(self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int) minutes"
            self.roundLabel.text = "\(self.roundsCompleted) Rounds Completed"
            let minutesStr = (self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int) > 9 ? String(self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int):"0" + String(self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int)
            self.timerLabel.text = "\(minutesStr):00:00"
        }
    }
    
    //MARK: IBAction functions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        var alertController = UIAlertController(title: "Enter Name", message: "Add a name for the workout", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            var name = (self.copiedWorkout ? self.workoutTemp!.name : "HIIT \(Date.toString(date: Date.getCurrentDate()))")   //check if the workout is a copy
            textField.placeholder = "NAME WORKOUT"
            textField.text = name
            textField.clearButtonMode = UITextFieldViewMode.Always
        }
        
        let textField = alertController.textFields![0] as! UITextField
        
        // Add the action to save the workout in CoreData using the WorkoutFactory Class, passing the workoutTemp object as the parameter
        let saveWorkoutAction = UIAlertAction(title: "Save Workout", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            var name = textField.text
            self.workoutTemp!.name = name
            self.workoutTemp!.timeCompleted = self.timerLabel.text!
            var workoutID = 0
            let defaults = NSUserDefaults.standardUserDefaults()
            if !self.copiedWorkout {
                workoutID = defaults.objectForKey(kWorkoutIDKey) as! Int
                workoutID++
                defaults.setObject(workoutID, forKey: kWorkoutIDKey)
            }
            else {
                workoutID = self.workoutTemp!.workoutID
            }
            self.workoutTemp!.roundsCompleted = self.roundsCompleted
            self.workoutFactory.saveWorkoutToCoreData(self.workoutTemp!, workoutID: workoutID, isCompleted: true)
            self.delegate!.dismissVC()
        }
        alertController.addAction(saveWorkoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func notesButtonPressed(sender: AnyObject) {
        let notesVC = self.storyboard?.instantiateViewControllerWithIdentifier("workoutNotes") as! WorkoutNotesViewController
        notesVC.delegate = self
        notesVC.notes = self.workoutTemp!.notes as String
        notesVC.isEdit = true
        self.showViewController(notesVC, sender: nil)
    }
    
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        self.timerStarted = true
        self.setTimeLimitButton.enabled = false
        if !self.timeLimitReached {
            if !self.timer.valid {
                self.elapsedTime = NSTimeInterval()
                self.startButton.setTitle("Stop", forState: UIControlState.Normal)
                let aSelector:Selector = "updateTimer"
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                self.startTime = NSDate.timeIntervalSinceReferenceDate()
            }
                
            else {
                self.pausedElapsedTime = self.elapsedTime
                self.startButton.setTitle("Start", forState: UIControlState.Normal)
                self.timer.invalidate()
            }
        }
        
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        self.timerStarted = false
        self.timeLimitReached = false
        self.setTimeLimitButton.enabled = true
        self.timer.invalidate()
        self.roundsCompleted = 0
        self.reloadView()
        if self.workoutTemp!.isAFAP {
            self.timerLabel.text = "00:00:00"
            self.watchTime = "00:00"
        }
        else {
            let minutesStr = (self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int) > 9 ? String(self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int):"0" + String(self.workoutTemp!.hiitAMREPDict.objectForKey(kTimeForAMRAP) as! Int)
            self.timerLabel.text = "\(minutesStr):00:00"
        }
        self.startButton.setTitle("Start", forState: UIControlState.Normal)
        self.pausedElapsedTime = NSTimeInterval()
        self.elapsedTime = NSTimeInterval()
    }
    
    @IBAction func setTimeLimitButtonPressed(sender: AnyObject) {
        if !self.timerStarted {
            var alertController = UIAlertController(title: "Set Time Limit", message: "Set the time limit for the HIIT workouts. Timer will stop when set time is reached.", preferredStyle: UIAlertControllerStyle.Alert)
            var defaults = NSUserDefaults.standardUserDefaults()
            alertController.addAction(UIAlertAction(title: "15 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(15, forKey: kTimeLimit)
                self.reloadView()
            }))
            
            alertController.addAction(UIAlertAction(title: "20 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(20, forKey: kTimeLimit)
                self.reloadView()
            }))
            alertController.addAction(UIAlertAction(title: "25 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(25, forKey: kTimeLimit)
                self.reloadView()
            }))
            alertController.addAction(UIAlertAction(title: "30 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(30, forKey: kTimeLimit)
                self.reloadView()
            }))
            alertController.addAction(UIAlertAction(title: "No Time Limit", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(-1, forKey: kTimeLimit)
                self.reloadView()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func updateCounter() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if self.workoutTemp!.isAFAP {
            if self.roundsCompleted <= self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int {
                self.roundLabel.text = "Round \(self.roundsCompleted) of \(self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int)"
                if self.roundsCompleted == self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int {
                    if defaults.boolForKey(kRoundStopTime) == true {
                        self.timer.invalidate()
                        self.startButton.setTitle("N/A", forState: UIControlState.Normal)
                        self.timeLimitReached = true
                    }
                }
            }
        }
        else {
            self.roundLabel.text = "\(self.roundsCompleted) Rounds Completed"
        }
    }
    
    
    //MARK: Touch Methods
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let tapCount = touch.tapCount
        
        let touchPoint = touch.locationInView(self.view)
        let pointX = touchPoint.x
        let pointY = touchPoint.y
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if tapCount == 2 {
            if pointX >= self.tapView.frame.origin.x && pointX <= self.tapView.frame.origin.x + self.tapView.frame.width {
                if pointY >= self.tapView.frame.origin.y && pointY <= self.tapView.frame.origin.y + self.tapView.frame.height {
                    println("touches began")
                    println("\(touchCount) touches")
                    println("\(tapCount) taps")
                    
                    if self.roundsCompleted < self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int {
                        self.roundsCompleted++
                    }
                    self.updateCounter()
                }
            }
        }
    }
    
    
    //MARK: WorkoutNotesVC Delegate methods
    
    func saveNotes(notes: String) {
        self.workoutTemp!.notes = notes
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: TableView Delegate and Data Source Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("executeHIITCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        let defaults = NSUserDefaults.standardUserDefaults()
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
        
        cell.textLabel?.text = self.exercises[indexPath.row].name
        cell.detailTextLabel?.text = "\(reps) \(repsUnit)"
        //cell.detailTextLabel?.text = "\(self.exercises[indexPath.row].reps[0]) \(repsUnit)"
        
        //*** This is the code to add changing the weight from metric to standard.
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //        var repsUnit = ""
        //        var reps = "\(exercises[indexPath.row].reps[0] as! Int)"
        //        switch exercises[indexPath.row].name {
        //        case "running":
        //            repsUnit = " m"
        //            reps = (defaults.objectForKey(kUnits) as! String == kMetric) ? "\(reps) \(kMeterUnits)" : "\(ConvertUnits.metersToMiles(reps.toInt()!)) \(kMileUnits))"
        //        case "planks":
        //            repsUnit = " sec"
        //        default:
        //            repsUnit = ""
        //        }
        //        //cell.repsLabel.text = "\(exercises[indexPath.row].reps[0]) \(repsUnit)"
        //        cell.detailTextLabel?.text = "\(reps) \(repsUnit)"
        //        cell.textLabel?.text = self.exercises[indexPath.row].name
        return cell
    }
    
    //MARK: - WatchKit Functions
    
    func uploadWorkoutToWatch(watchKitInfo:WatchKitInfo) {
        
        var exercisesToLoad:[AnyObject] = []
        var repsToLoad:[AnyObject] = []
        
        for ex in self.exercises {
            exercisesToLoad.append(ex.name)
            repsToLoad.append(ex.reps[0] as! Int)
        }
        
        var exerciseDict:Dictionary<String,[AnyObject]> = ["exercises":exercisesToLoad, "reps": repsToLoad]
        var uploadDict:Dictionary<String,AnyObject> = ["ExerciseDict":exerciseDict, "Count":self.roundsCompleted, "ElapsedTime":self.elapsedTime, "RoundsToComplete":self.workoutTemp!.hiitAFAPDict.objectForKey(kNumberOfRounds) as! Int]
        //watchKitInfo.replyBlock(["Upload":uploadDict])
        watchKitInfo.replyBlock(uploadDict)
        
    }
    
    func syncDataWithWatch(watchKitInfo:WatchKitInfo) {
//        var uploadDict:Dictionary<String,AnyObject> = ["Count":self.roundsCompleted, "timerStatus" : self.startButton.titleForState(UIControlState.Normal)!]
        var uploadDict:Dictionary<String,AnyObject> = ["Count":self.roundsCompleted, "Time":self.watchTime, "TimerButtonLabel":self.startButton.titleForState(UIControlState.Normal)!]
        watchKitInfo.replyBlock(uploadDict)
    }
    
    func handleRequest(notification: NSNotification) {
        let watchKitinfo = notification.object! as! WatchKitInfo
        
        if watchKitinfo.playerRequest != nil {
            let requestAction: String = watchKitinfo.playerRequest!
            
            switch requestAction {
            case "startStopTimer":
                self.startButtonPressed(UIButton())
            case "increaseCount":
                self.roundsCompleted++
                self.updateCounter()
            case "uploadWorkout":
                self.uploadWorkoutToWatch(watchKitinfo)
            case "resetTimer":
                self.resetButtonPressed(UIButton())
            case "resetCounter":
                self.roundsCompleted = 0
                self.updateCounter()
            case "updateData":
                self.syncDataWithWatch(watchKitinfo)
            default:
                println("Default Value printed for Watch switch")
            }
        }
    }
    
}
