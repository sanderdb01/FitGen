//
//  ViewController.swift
//  FitGen
//
//  Created by David Sanders on 11/24/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var exercises:[DefaultExercise] = []
    var exerciseFactory = ExerciseFactory()
    let constants = Constants()
    var workout:Workout!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        exerciseFactory.loadDefaultExercises()
        
        self.exerciseFactory.addNewExercise(name: "kettlebell row", weight: 32, workoutType: constants.kHIIT, generalBodyLocation: constants.kUpper, specificBodyLocation: constants.kTotal, workoutLocation: constants.kGym, isHIIT: true, isStrength: false, isCardio: false, isEnabled: true)
        self.exercises = exerciseFactory.returnDefaultExerciseArray()
        
        var testExercise:DefaultExercise = self.exercises[0] as DefaultExercise
        self.exerciseFactory.deleteExercise(exercise: testExercise)
        
        var workoutFactory = WorkoutFactory()
        //self.workout = workoutFactory.generateHIITWorkout(workoutLocation: constants.kGym, generalBodyLocation: constants.kTotal, difficultyLevel: 2, isAFAP: true)

        self.exercises = exerciseFactory.returnDefaultExerciseArray()
        
        println(Date.toString(date: Date.getCurrentDate()))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var test:[WorkoutExercise] = self.workout.hiitAFAPDict.objectForKey(constants.kExercises) as! Array
        return test.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
//        let exercise:DefaultExercise = self.exercises[indexPath.row] as DefaultExercise
//        cell.textLabel?.text = exercise.name
//        cell.detailTextLabel?.text = exercise.workoutLocation
        
        var test:[WorkoutExercise] = self.workout.hiitAFAPDict.objectForKey(constants.kExercises) as! Array
        var ex:WorkoutExercise = test[indexPath.row] as WorkoutExercise
        var reps:[Int] = ex.reps as! Array
        cell.textLabel?.text = ex.name
        cell.detailTextLabel?.text = "\(reps[0] as Int)"
        
        return cell
        
    }


}

