//
//  WorkoutFactory.swift
//  FitGen
//
//  Created by David Sanders on 11/24/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WorkoutFactory
{
    let constants = Constants()
    
    //MARK: Generate HIIT Workout
    func generateHIITWorkout(#workoutLocation: String, generalBodyLocation: String, difficultyLevel: Int, isAFAP: Bool, isCardioCore: Bool) -> WorkoutTemp
    {
        var numberOfExercises = 0                   // number of exercises in the workout
        var difficultyLevelSet = 0                  // difficulty level set reps for the exercises
        var allExercises:[AnyObject] = []           // array of all the exercises that meet the criteria from the filter
        var chosenExercises:[DefaultExercise] = []  // array of the chosen exercises
        var workoutExercises:[WorkoutExercise] = [] // array of the final workout exercises
        var timeAMRAP = 0                           // time in which the workout must be done if it is an AMRAP.
        var numberOfRounds = 1                      // number of rounds if AFAP
        
        //***** fetch the Default Exercises that are filtered by the workout location and the general body location.
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        var predicateArray:[NSPredicate] = []
        
        if workoutLocation == constants.kHome
        {
            var predicateExerciseLocation = NSPredicate(format:"workoutLocation == %@",workoutLocation)
            predicateArray.append(predicateExerciseLocation)
        }
        else
        {
            var predicateExerciseLocation1 = NSPredicate(format:"workoutLocation == %@",constants.kHome)
            var predicateExerciseLocation2 = NSPredicate(format:"workoutLocation == %@",constants.kGym)
            let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateExerciseLocation1 ,predicateExerciseLocation2])
            predicateArray.append(predicate)
        }
        
        if isCardioCore {
            var predicateCardio = NSPredicate(format:"workoutType == %@", kCardio)
            var predicateCore = NSPredicate(format: "specificBodyLocation == %@", kCore)
            let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateCardio, predicateCore])
            predicateArray.append(predicate)
        }
        else {
            if generalBodyLocation == constants.kTotal
            {
                let predicateGeneralBodyLocationUpper = NSPredicate(format:"generalBodyLocation == %@", constants.kUpper)
                let predicateGeneralBodyLocationLower = NSPredicate(format:"generalBodyLocation == %@", constants.kLower)
                let predicateGeneralBodyLocationTotal = NSPredicate(format:"generalBodyLocation == %@", constants.kTotal)
                let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateGeneralBodyLocationUpper,predicateGeneralBodyLocationLower, predicateGeneralBodyLocationTotal])
                predicateArray.append(predicate)
            }
            else
            {
                let predicateGeneralBodyLocation = NSPredicate(format:"generalBodyLocation == %@", generalBodyLocation)
                let predicateGeneralBodyLocationTotal = NSPredicate(format:"generalBodyLocation == %@", constants.kTotal)
                let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateGeneralBodyLocation, predicateGeneralBodyLocationTotal])
                predicateArray.append(predicate)
            }
        }
        
        //check to make sure the exercise is enabled
        let predicateEnabled = NSPredicate(format: "isEnabled == true")
        predicateArray.append(predicateEnabled)
        
        //check to make sure that the exercise is set for HIIT or is a cardio
        let predicateHIIT = NSPredicate(format: "isHIIT == true")
        let predicateCardio = NSPredicate(format: "isCardio == true")
        let predicateWorkoutType = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateHIIT, predicateCardio])
        predicateArray.append(predicateWorkoutType)
        
        // add the predicate array and apply it to the fetch
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicateArray)
        request.predicate = predicate
        
        allExercises = context.executeFetchRequest(request, error: nil)!
        
        // test the fetched exercises
        for exercise in allExercises
        {
            var ex:DefaultExercise = exercise as! DefaultExercise
            println(ex.name)
        }
        //***** choose the number of exercises and individual difficulty level for the exercises
        switch difficultyLevel
        {
        case 1:
            numberOfExercises = Int(arc4random_uniform(UInt32(2))) + 2
            if numberOfExercises == 2 || numberOfExercises == 3
            {
                difficultyLevelSet = 1
            }
        case 2:
            numberOfExercises = Int(arc4random_uniform(UInt32(3))) + 2
            if numberOfExercises == 2 || numberOfExercises == 3
            {
                difficultyLevelSet = 2
            }
            else
            {
                difficultyLevelSet = 1
            }
        case 3:
            numberOfExercises = Int(arc4random_uniform(UInt32(4))) + 2
            if numberOfExercises == 2 || numberOfExercises == 3
            {
                difficultyLevelSet = 3
            }
            else if numberOfExercises == 4
            {
                difficultyLevelSet = 2
            }
            else
            {
                difficultyLevelSet = 1
            }
        case 4:
            numberOfExercises = Int(arc4random_uniform(UInt32(4))) + 2
            if numberOfExercises == 2 || numberOfExercises == 3
            {
                difficultyLevelSet = 4
            }
            else if numberOfExercises == 4
            {
                difficultyLevelSet = 3
            }
            else if numberOfExercises == 5
            {
                difficultyLevelSet = 2
            }
            else
            {
                difficultyLevelSet = 1
            }
        default:
            println("Switch statement default")
        }
        
        //******Verify that the number of exercises chosen is not greater than the amount available. If so, make it equal to "allExercises"
        if numberOfExercises > allExercises.count {
            numberOfExercises = allExercises.count
        }
        
        //***** Choose the exercises for the workout and add them to array chosenExercises
        for var x = 0; x < numberOfExercises; x++
        {
            let rand = Int(arc4random_uniform(UInt32(allExercises.count - 1)))
            chosenExercises.append(allExercises[rand] as! DefaultExercise)
            allExercises.removeAtIndex(rand)
        }
        
        // test the chosen exercises
        println("Number of exercises: \(numberOfExercises)")
        for exercise in chosenExercises
        {
            var ex:DefaultExercise = exercise
            println("Chosen Exercise:  \(ex.name)")
        }
        
        //***** Convert the chosen exercises to Workout Exercises, with the reps divided by the number of rounds. Generate both the number of rounds for AFAP and the time for AMRAP
        //if the workout is a AMREP, it makes the minumum number of rounds 2 and the max 5
        if isAFAP{
            numberOfRounds = Int(arc4random_uniform(UInt32(6))) + 1
        }
        else {
            numberOfRounds = Int(arc4random_uniform(UInt32(4))) + 2
        }
        
        let timeMultiple = Int(arc4random_uniform(UInt32(3))) + 2
        timeAMRAP = timeMultiple * 5
        
        for defaultExercise in chosenExercises
        {
            var reps:[Int] = []
            var weight:[Int] = []
            
            var exercise:DefaultExercise = defaultExercise as DefaultExercise
            
            weight.append(Int(exercise.weight))
            
            switch difficultyLevelSet
            {
            case 1:
                reps.append(Int(exercise.level1Reps) / numberOfRounds)
            case 2:
                reps.append(Int(exercise.level2Reps) / numberOfRounds)
            case 3:
                reps.append(Int(exercise.level3Reps) / numberOfRounds)
            case 4:
                reps.append(Int(exercise.level4Reps) / numberOfRounds)
            default:
                reps.append(0)
            }
            let testName = exercise.name
            var ex:WorkoutExercise = WorkoutExercise(name: exercise.name, date: Date.getCurrentDate(), workoutType: exercise.workoutType, specificBodyLocation: exercise.specificBodyLocation, generalBodyLocation: exercise.generalBodyLocation, superset: 0, weight: weight, reps: reps, howTo: exercise.howTo)
            workoutExercises.append(ex)
        }
        
        //***** See if HIIT is a AFAP or AMRAP. Then assign numbers accordingly
        //***** Create the WorkoutTemp according to if it is an AMRAP or AFAP
        
        var newWorkout = WorkoutTemp()
        
        if isAFAP
        {
            newWorkout.name = "New Workout"
            newWorkout.date = Date.getCurrentDate()
            newWorkout.workoutType = constants.kHIIT
            newWorkout.superset = false
            newWorkout.strengthArray = []
            newWorkout.supersetArray = []
            newWorkout.hiitAFAPDict = [constants.kExercises: workoutExercises, constants.kNumberOfRounds: numberOfRounds]
            newWorkout.hiitAMREPDict = []
            newWorkout.isAFAP = true
            newWorkout.isAMRAP = false
            newWorkout.timeCompleted = ""
            newWorkout.isComplete = false
            newWorkout.notes = ""
            newWorkout.numberOfRounds = numberOfRounds
        }
        else
        {
            newWorkout.name = "New Workout"
            newWorkout.date = Date.getCurrentDate()
            newWorkout.workoutType = constants.kHIIT
            newWorkout.superset = false
            newWorkout.strengthArray = []
            newWorkout.supersetArray = []
            newWorkout.hiitAFAPDict = []
            newWorkout.hiitAMREPDict = [constants.kExercises: workoutExercises, constants.kTimeForAMRAP: timeAMRAP]
            newWorkout.isAMRAP = true
            newWorkout.isAFAP = false
            newWorkout.timeCompleted = ""
            newWorkout.isComplete = false
            newWorkout.notes = ""
            newWorkout.numberOfRounds = numberOfRounds
        }
        
        return newWorkout
    }
    
    //MARK: Generate Strength Workout
    func generateStrengthWorkout(#workoutLocation: String, bodyParts:[String], numberOfExercises:Int = 0, isSuperSet:Bool) -> (WorkoutTemp, Bool)
    {
        var allExercises:[AnyObject] = []           // array of all the exercises that meet the criteria from the filter
        var chosenExercises:[DefaultExercise] = []  // array of the chosen exercises
        var workoutExercises:[WorkoutExercise] = [] // array of the final workout exercises with workout specifc details (note the class in array)
        var isNumberOfExercisesExceeded = false     // Bool that returns if the number of Exercises requested exceeds the number in the DB
        
        //***** fetch the Default Exercises that are filtered by the workout location and the specific body location/s.
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        var predicateArray:[NSPredicate] = []
        
        if workoutLocation == constants.kHome
        {
            var predicateExerciseLocation = NSPredicate(format:"workoutLocation == %@",workoutLocation)
            predicateArray.append(predicateExerciseLocation)
        }
        else
        {
            var predicateExerciseLocation1 = NSPredicate(format:"workoutLocation == %@",constants.kHome)
            var predicateExerciseLocation2 = NSPredicate(format:"workoutLocation == %@",constants.kGym)
            let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicateExerciseLocation1 ,predicateExerciseLocation2])
            predicateArray.append(predicate)
        }
        
        //Cycle through all of the body parts passed into the function and filter by the ones listed, adding to the predicate
        var bodyPartsPredicatesArray:[NSPredicate] = [] // Array that holds all of the body part predicates
        for bodyPart in bodyParts
        {
            if bodyPart == self.constants.kChest {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kChest)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kBack {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kBack)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kShoulders {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kShoulders)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kCore {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kCore)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kBiceps {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kBiceps)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kTriceps {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kTriceps)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kLegs {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kLegs)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
            if bodyPart == self.constants.kTotal {
                let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", constants.kTotal)
                bodyPartsPredicatesArray.append(predicateBodyPart)
            }
        }
        
        let predicateBodyPartsCompound = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: bodyPartsPredicatesArray)
        predicateArray.append(predicateBodyPartsCompound)
        
        //check to make sure the exercise is enabled
        let predicateEnabled = NSPredicate(format: "isEnabled == true")
        predicateArray.append(predicateEnabled)
        
        //check to make sure that the exercise is set for Strength
        let predicateWorkoutType = NSPredicate(format: "isStrength == true")
        predicateArray.append(predicateWorkoutType)
        
        // add the predicate array and apply it to the fetch
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicateArray)
        request.predicate = predicate
        
        allExercises = context.executeFetchRequest(request, error: nil)!
        
        // test the fetched exercises
        for exercise in allExercises
        {
            var ex:DefaultExercise = exercise as! DefaultExercise
            println(ex.name)
        }
        
        //***** Choose the exercises for the workout and add them to array chosenExercises
        for eachBodyPart in bodyParts   // Cycles through all of the chosen body parts
        {
            for var x = 0; x < numberOfExercises; x++   //adds the number of exercises for that specific body part (if available)
            {
                if allExercises.count > 0   // Checks to make sure that there is at least one exercise in the array. If not, then that means that the requested number                of workouts exceeds the number in the DB, or there are not enough exercises that meet the criteria (ie. isEnabled)
                {
                    var rand = 0
                    var isSearchComplete = false    //Sets if an exercise was actually chosen or not. Only useful if chosen number of exerciese exceeds the ones in the DB
                    var tempAllExercises:[DefaultExercise] = [] // Variable to hold a temp exercise array with all the exercises. This is the one that will be compared to in the building of the workout, and then reset after each search
                    var isExerciseAdded = false   // Flag indicating if an exercise was added to chosenExercises. Used in determing if number of exercises is exceeded
                    for defaultEx in allExercises {     // "copy" the allExercise array
                        
                        tempAllExercises.append((defaultEx as! DefaultExercise))
                    }
                    do {    // Do loop based on if searching the exercise array is complete or not (either a match was found, or came to the end of the array)
                        rand = Int(arc4random_uniform(UInt32(tempAllExercises.count - 1)))  //Generate random number based on the exercises in the tempAllExercise Array
                        
                        // If the searched body part equals the currently checked exercise body part, add it to chosenExercise array and flag that search is complete
                        var test:String = (tempAllExercises[rand] as DefaultExercise).specificBodyLocation
                        
                        if (tempAllExercises[rand] as DefaultExercise).specificBodyLocation == eachBodyPart
                        {
                            isSearchComplete = true
                            chosenExercises.append(tempAllExercises[rand] as DefaultExercise)
                            isExerciseAdded = true
                        }
                        
                        tempAllExercises.removeAtIndex(rand)    //Remove the exercise from the temp array (whether it is a match or not)
                        
                        if tempAllExercises.count == 0 && !isExerciseAdded {    // There are no more exercises to check, so the amount of chosen exercises was too high
                            isSearchComplete = true
                            isNumberOfExercisesExceeded = true
                        }
                        
                    } while !isSearchComplete
                    
                    // Loop through all of the elements in allExercises and if the most recently added chosenExercise element matches, delete ex from allExercises and break out of loop
                    for var index = 0; index < allExercises.count; index++ {
                        if chosenExercises.count != 0 {    //Check to make sure that there was at least 1 exercise to be added to the workout (lack of line was resulting in a crash)
                            if (chosenExercises.last! as DefaultExercise).name == (allExercises[index] as! DefaultExercise).name {
                                allExercises.removeAtIndex(index)
                                break
                            }
                        }
                    }
                } else
                {
                    isNumberOfExercisesExceeded = true
                }
            }
        }
        
        // test the chosen exercises
        println("Number of exercises: \(numberOfExercises)")
        for exercise in chosenExercises
        {
            var ex:DefaultExercise = exercise as DefaultExercise
            println("Chosen Exercise:  \(ex.name)")
        }
        
        
        //********** Convert the chosenExercises to WorkoutExercises to eventually be added to the WorkoutTemp Class object ***********//
        for defaultExercise in chosenExercises
        {
            var exercise:DefaultExercise = defaultExercise as DefaultExercise
            
            var reps:[Int] = [10,10,10]
            var weight:[Int] = [Int(exercise.weight),Int(exercise.weight),Int(exercise.weight)]
            
            var ex:WorkoutExercise = WorkoutExercise(name: exercise.name, date: Date.getCurrentDate(), workoutType: exercise.workoutType, specificBodyLocation: exercise.specificBodyLocation, generalBodyLocation: exercise.generalBodyLocation, superset: 0, weight: weight, reps: reps, howTo: exercise.howTo)
            workoutExercises.append(ex)
        }
        
        //********** Create the new WorkoutTemp object (determines if it is a superset or not as well) *****************//
        var newWorkout = WorkoutTemp()
        
        if !isSuperSet
        {
            newWorkout.name = "New Workout"
            newWorkout.date = Date.getCurrentDate()
            newWorkout.workoutType = constants.kStrength
            newWorkout.superset = false
            newWorkout.strengthArray = workoutExercises
            newWorkout.supersetArray = []
            newWorkout.hiitAFAPDict = []
            newWorkout.hiitAMREPDict = []
            newWorkout.isAFAP = false
            newWorkout.isAMRAP = false
            newWorkout.timeCompleted = ""
            newWorkout.isComplete = false
            newWorkout.notes = ""
            
            return (newWorkout, isNumberOfExercisesExceeded)
            
        } else
        {
            return (WorkoutTemp(), isNumberOfExercisesExceeded)
        }
        
        
    }
    
    //MARK: General Workout Helper Functions
    func saveWorkoutToCoreData(workout: WorkoutTemp, workoutID:NSNumber, isCompleted:Bool) -> Workout
    {
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let entityDescription = NSEntityDescription.entityForName("Workout", inManagedObjectContext: context)
        let newWorkout = Workout(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        newWorkout.name = workout.name
        newWorkout.date = workout.date
        newWorkout.workoutType = workout.workoutType
        newWorkout.superset = workout.superset
        newWorkout.strengthArray = workout.strengthArray
        newWorkout.supersetArray = workout.superset
        newWorkout.hiitAFAPDict = workout.hiitAFAPDict
        newWorkout.hiitAMREPDict = workout.hiitAMREPDict
        newWorkout.isAFAP = workout.isAFAP
        newWorkout.isAMRAP = workout.isAMRAP
        newWorkout.timeCompleted = workout.timeCompleted
        newWorkout.isComplete = isCompleted
        newWorkout.notes = workout.notes
        newWorkout.workoutID = workoutID
        newWorkout.roundsCompleted = workout.roundsCompleted
        newWorkout.score = workout.score
        
        appDelegate.saveContext()
        
        return newWorkout   //Added in case the new workout object is needed
        
    }
    
    func returnWorkoutTempFromWorkout(workout: Workout) -> WorkoutTemp {
        var workoutTemp:WorkoutTemp = WorkoutTemp()
        var name:String = workout.name
        
        workoutTemp.name = workout.name
        workoutTemp.date = workout.date
        workoutTemp.workoutType = workout.workoutType
        workoutTemp.superset = workout.superset
        workoutTemp.strengthArray = workout.strengthArray
        workoutTemp.supersetArray = workout.superset
        workoutTemp.hiitAFAPDict = workout.hiitAFAPDict
        workoutTemp.hiitAMREPDict = workout.hiitAMREPDict
        workoutTemp.isAFAP = workout.isAFAP
        workoutTemp.isAMRAP = workout.isAMRAP
        workoutTemp.timeCompleted = workout.timeCompleted
        workoutTemp.isComplete = workout.isComplete
        workoutTemp.notes = workout.notes
        workoutTemp.workoutID = workout.workoutID.integerValue
        workoutTemp.roundsCompleted = workout.roundsCompleted
        workoutTemp.score = workout.score.integerValue
        
        return workoutTemp
    }
    
    func returnWorkoutArray() -> [Workout]
    {
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: "Workout")
        var coredataWorkouts:[AnyObject] = context.executeFetchRequest(request, error: nil)!
        
        var allWorkouts:[Workout] = []
        
        for exercise in coredataWorkouts
        {
            allWorkouts.append(exercise as! Workout)
        }
        allWorkouts = allWorkouts.sorted({ (exOne:Workout, exTwo:Workout) -> Bool in
            return exOne.date.timeIntervalSince1970 < exTwo.date.timeIntervalSince1970
        })
        
        return allWorkouts
    }
    
    func deleteWorkout(#workout: Workout)
    {
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        context.deleteObject(workout)
        appDelegate.saveContext()
    }
}
