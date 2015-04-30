//
//  InterfaceController.swift
//  FitGen WatchKit Extension
//
//  Created by David Sanders on 4/22/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import WatchKit
import Foundation

let key = "FunctionRequestKey"

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var timerLabel: WKInterfaceTimer!
    @IBOutlet weak var timerButton: WKInterfaceButton!
    @IBOutlet weak var roundCounterButton: WKInterfaceButton!
    @IBOutlet weak var timerButtonLarger: WKInterfaceButton!
    @IBOutlet weak var roundCounterButtonLarger: WKInterfaceButton!
    
    var uploadDict = Dictionary<String,AnyObject>()
    //var exerciseDict:Dictionary<String,[AnyObject]> = ["exercises":[], "reps": []]  //Dictionary of 2 arrays key:"exercises" = [Strings of exercise names] key:"reps" = [Ints of reps]. The indexes of the exercises and the reps match
    var exerciseDict = Dictionary<String,[AnyObject]>()
    var exercises = []  //array of String exercise names
    var reps = []   //array of Int exercise reps
    
    var currentView = 0
    
    //TIMER AND COUNTER VARIABLES
    var timer = NSTimer()
    var timerRunning:Bool = false
    var count:Int = 0
    var rounds:Int = 0
    var isTimerInit = false
    var testDate = NSDate()
    var startTime = NSDate()
    var holdDate = NSDate()
    var timeToAdd:NSTimeInterval = 0
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        //setup initial view
        self.roundCounterButton.setHidden(false)
        self.timerButton.setHidden(false)
        self.table.setHidden(false)
        self.roundCounterButtonLarger.setHidden(true)
        self.timerButtonLarger.setHidden(true)
        self.currentView = 0
        
        //Set timer data
        self.timerLabel.setDate(NSDate())
        self.timerLabel.stop()
        self.roundCounterButton.setTitle("0 of 0")
        self.roundCounterButtonLarger.setTitle("0/0")
        self.timerButtonLarger.setTitle("Start")
        
        //Set exercise info
        self.exerciseDict  = ["exercises":["Exercise"], "reps": [0]]
        self.exercises = self.exerciseDict["exercises"]!
        self.reps = self.exerciseDict["reps"]! as! [Int]
        //self.loadExercises()
        self.updateTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        //For updating the view from the Phone
        self.timer.invalidate()
    }
    
    func updateTable() {
        if self.exercises.count != 0 {
            self.table.setNumberOfRows(self.exercises.count, withRowType: "ExerciseRow")
            
            for var index = 0; index < self.exercises.count; index++ {
                 var theRow = self.table.rowControllerAtIndex(index) as! ExerciseRow
                theRow.exerciseNameLabel.setText(self.exercises[index] as? String)
                theRow.repsLabel.setText("\(self.reps[index] as! Int)")
            }
        }
    }
    //MARK: - Load the exercise from iPhone
    func loadExercises() {
        self.timer.invalidate()
        self.exercises = self.exerciseDict["exercises"]!
        self.reps = self.exerciseDict["reps"]! as! [Int]
        self.syncWithPhone()
    }
    
    //MARK: - Sync the data between the iPhone and the iWatch
    func syncWithPhone() {
        let aSelector:Selector = "updateTimer"
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        var info = [key : "updateData"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            if reply != nil {
                //self.uploadDict = (reply as? [String:AnyObject])!
                let upload = (reply as? [String:AnyObject])!
                println("\(self.uploadDict)")
                //Set the Count
                self.count = upload["Count"] as! Int
                self.roundCounterButton.setTitle("\(self.count) of \(self.rounds)")
                self.roundCounterButtonLarger.setTitle("\(self.count)/\(self.rounds)")
                //Set the timer
                let timerStatus = upload["timerStatus"] as! String
                if (timerStatus == "Start" && self.timerRunning) || (timerStatus == "Stop" && !self.timerRunning){
                    //Control the iWatch Timer
                    if !self.isTimerInit {
                        self.testDate = NSDate()
                        self.isTimerInit = true
                    }
                    if !self.timerRunning {
                        self.testDate = NSDate()
                        self.testDate = self.testDate.dateByAddingTimeInterval(self.timeToAdd)
                        self.timerLabel.setDate(self.testDate)
                        self.timerLabel.start()
                        self.timerButton.setTitle("Stop")
                        self.timerButtonLarger.setTitle("Stop")
                        self.timerRunning = true
                    } else {
                        self.timeToAdd = self.testDate.timeIntervalSinceDate(NSDate())
                        self.timerRunning = false
                        //self.mainTimer.setDate(NSDate())
                        self.timerLabel.stop()
                        self.timerButton.setTitle("Start")
                        self.timerButtonLarger.setTitle("Start")
                    }
                }
            } else {
                println("update not performed")
            }
            println("reply \(reply) error \(error)")
        })
    }
    
    //MARK:- IBActions
    
    @IBAction func timerButtonPressed() {
        
        //Control the iWatch Timer
        if !self.isTimerInit {
            self.testDate = NSDate()
            self.isTimerInit = true
        }
        if !self.timerRunning {
            self.testDate = NSDate()
            self.testDate = testDate.dateByAddingTimeInterval(self.timeToAdd)
            self.timerLabel.setDate(self.testDate)
            self.timerLabel.start()
            self.timerButton.setTitle("Stop")
            self.timerButtonLarger.setTitle("Stop")
            self.timerRunning = true
        } else {
            self.timeToAdd = self.testDate.timeIntervalSinceDate(NSDate())
            self.timerRunning = false
            //self.mainTimer.setDate(NSDate())
            self.timerLabel.stop()
            self.timerButton.setTitle("Start")
            self.timerButtonLarger.setTitle("Start")
        }
        
        //Interface with the iPhone app
        var info = [key : "startStopTimer"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            
            println("reply \(reply) error \(error)")
        })
    }
    
    
    @IBAction func roundCounterButtonPressed() {
        self.count++
        self.roundCounterButton.setTitle("\(self.count) of \(self.rounds)")
        self.roundCounterButtonLarger.setTitle("\(self.count)/\(self.rounds)")
        
        //Interface with the iPhone app
        var info = [key : "increaseCount"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            
            println("reply \(reply) error \(error)")
        })
        
    }
    
    
    @IBAction func updateExercisesMenuButtonPressed() {
        //Load exercise from iPhone
        //Interface with the iPhone app
        var info = [key : "uploadWorkout"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            
            if reply != nil {
                self.uploadDict = (reply as? [String:AnyObject])!
                println("\(self.uploadDict)")
                self.exerciseDict = self.uploadDict["ExerciseDict"] as! Dictionary<String,[AnyObject]>
                self.count = self.uploadDict["Count"] as! Int
                //self.timeToAdd = self.uploadDict["ElapsedTime"]
                self.rounds = self.uploadDict["RoundsToComplete"] as! Int
                self.loadExercises()
                self.updateTable()
                self.roundCounterButton.setTitle("\(self.count) of \(self.rounds)")
                self.roundCounterButtonLarger.setTitle("\(self.count)/\(self.rounds)")
            } else {
                self.exerciseDict  = ["exercises":["None Available",], "reps": [0]]
                self.loadExercises()
                self.updateTable()
            }
            println("reply \(reply) error \(error)")
        })
    }
    
    @IBAction func resetTimerMenuButtonPressed() {
        self.timerLabel.setDate(NSDate())
        self.timerLabel.stop()
        self.isTimerInit  = false
        self.timeToAdd = 0
        self.timerButton.setTitle("Start")
        self.timerButtonLarger.setTitle("Start")
        
        //So it works the samne as the iPhone portion
        self.count = 0
        self.roundCounterButton.setTitle("\(self.count) of \(self.rounds)")
        self.roundCounterButtonLarger.setTitle("\(self.count)/\(self.rounds)")
        
        //Interface with the iPhone app
        var info = [key : "resetTimer"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            
            println("reply \(reply) error \(error)")
        })
    }
    
    @IBAction func resetCounterMenuButtonPressed() {
        self.count = 0
        self.roundCounterButton.setTitle("\(self.count) of \(self.rounds)")
        self.roundCounterButtonLarger.setTitle("\(self.count)/\(self.rounds)")
        
        //Interface with the iPhone app
        var info = [key : "resetCounter"]
        WKInterfaceController.openParentApplication(info, reply: { (reply, error) -> Void in
            
            println("reply \(reply) error \(error)")
        })
    }
    
    @IBAction func switchViewsMenuButtonPressed() {
        if currentView == 1 {
            self.roundCounterButton.setHidden(false)
            self.timerButton.setHidden(false)
            self.table.setHidden(false)
            self.roundCounterButtonLarger.setHidden(true)
            self.timerButtonLarger.setHidden(true)
            self.currentView = 0
        } else {
            self.roundCounterButton.setHidden(true)
            self.timerButton.setHidden(true)
            self.table.setHidden(true)
            self.roundCounterButtonLarger.setHidden(false)
            self.timerButtonLarger.setHidden(false)
            self.currentView = 1
        }
    }
    
    

}
