//
//  ExerciseFactory.swift
//  FitGen
//
//  Created by David Sanders on 11/25/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ExerciseFactory: NSFetchedResultsControllerDelegate
{
    
    func loadDefaultExercises() //** delete all of the default exercises from core data and replace them with the data in the plist. **//
    {
        //Create a constants object to manage all of the keywords and strings used in the data management (until a better idea like in Obj-C #define)
        
        let constants = Constants()
        
        //variable to hold all of the exercises already in core data
        var oldExercises:[AnyObject] = []
        
        // generate the usual core data variables to work with
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        oldExercises = context.executeFetchRequest(request, error: nil)!
        println("number of old exercises saved: \(oldExercises.count)") //just ot test the number of exercises in COreData before anything is changed
        
        //If the count of oldExercises is greater than 0, then iterate through all of the previously saved exercises and delete them
        if oldExercises.count > 0
        {
            var numberOfExercies = oldExercises.count
            for var x = 0; x < numberOfExercies; x++
            {
                var exercise:DefaultExercise = oldExercises[x] as! DefaultExercise
                context.deleteObject(exercise)
            }
            
            appDelegate.saveContext()
            
            //just a check
            oldExercises = context.executeFetchRequest(request, error: nil)!
            println("number of exercises left after deletion: \(oldExercises.count)") //just ot test the number of exercises in COreData before anything is changed
        }
        
        // After deletion, save all of the exercises in the defaultExercises plist file as a dictionary, and an array of all the names
        let bundle:NSBundle = NSBundle.mainBundle()
        let plistURL:NSURL = bundle.URLForResource("defaultExercises", withExtension: "plist")!
        //var exercisesFromFile:NSDictionary = NSDictionary(contentsOfURL: plistURL)  //NSDictionary of the contents in the plist file with all exercise data
        var exercisesFromFile:NSDictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("defaultExercises", ofType: "plist")!)!
        var allExercises:[AnyObject] = exercisesFromFile.allKeys    //array of all the keys in the dictionary (the names of the workouts)
        
        // printing out all the names of the exercises that were saved as a test
        for x in allExercises
        {
            println("exercise: \(x)")
        }
        
        //iterate through all of the exercises in the list and create new DefaultExercises objects in Core Data based off of the dictionary data
        for exercise in allExercises
        {
            //create the new added exercise entity
            let entityDescription = NSEntityDescription.entityForName("DefaultExercise", inManagedObjectContext: context)
            let addedExercise = DefaultExercise(entity: entityDescription!, insertIntoManagedObjectContext: context)
            
            //individual exercise data in dictionary format from the plist
            let exerciseDictionary:NSDictionary = exercisesFromFile.objectForKey(exercise) as! NSDictionary
            
            // set the values for the addedExercise entity
            addedExercise.name = exercise as! String
            addedExercise.weight = exerciseDictionary.objectForKey(kWeight) as! Int
            addedExercise.workoutType = exerciseDictionary.objectForKey(kWorkoutType) as! String
            addedExercise.generalBodyLocation = exerciseDictionary.objectForKey(kGeneralBodyLocation) as! String
            addedExercise.specificBodyLocation = exerciseDictionary.objectForKey(kSpecificBodyLocation) as! String
            addedExercise.level1Reps = exerciseDictionary.objectForKey(kLevel1Reps) as! Int
            addedExercise.level2Reps = exerciseDictionary.objectForKey(kLevel2Reps) as! Int
            addedExercise.level3Reps = exerciseDictionary.objectForKey(kLevel3Reps) as! Int
            addedExercise.level4Reps = exerciseDictionary.objectForKey(kLevel4Reps) as! Int
            addedExercise.workoutLocation = exerciseDictionary.objectForKey(kWorkoutLocation) as! String
            addedExercise.isEnabled = true
            addedExercise.howTo = exerciseDictionary.objectForKey(kHowTo) as! String
            
            // set the addedExercises workoutTypes boolean
            switch addedExercise.workoutType
                {
            case constants.kHIIT:
                addedExercise.isHIIT = true
            case constants.kStrength:
                addedExercise.isStrength = true
            case constants.kCardio:
                addedExercise.isCardio = true
            default:
                println("There is no correct workout type")
            }
            
            appDelegate.saveContext()
        }
        
        //just a check
        var newExercises:[AnyObject] = context.executeFetchRequest(request, error: nil)!
        println("number of new exercises saved: \(newExercises.count)") //just ot test the number of exercises in CoreData before anything is changed
        
        
    }
    
    func updateExercise(#exerciseToDelete:DefaultExercise, weight:NSNumber, workoutType:String, generalBodyLocation:String, specificBodyLocation:String, level1Reps:Int = 20, level2Reps:Int = 40, level3Reps:Int = 60, level4Reps:Int = 80, workoutLocation:String, isHIIT:Bool, isStrength:Bool, isCardio:Bool, isEnabled: Bool, howTo:String) -> DefaultExercise //** updates the exercise in the DefaultExercise DB. Creates a new DefaultExercise entity, but keeps the name of the supplied one in the parameters.  **\\
    {
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let entityDescription = NSEntityDescription.entityForName("DefaultExercise", inManagedObjectContext: context)
        
        // set the values for the addedExercise entity
        let addedExercise = DefaultExercise(entity: entityDescription!, insertIntoManagedObjectContext: context)
        addedExercise.name = exerciseToDelete.name
        addedExercise.weight = weight
        addedExercise.workoutType = workoutType
        addedExercise.generalBodyLocation = generalBodyLocation
        addedExercise.specificBodyLocation = specificBodyLocation
        addedExercise.level1Reps = level1Reps
        addedExercise.level2Reps = level2Reps
        addedExercise.level3Reps = level3Reps
        addedExercise.level4Reps = level4Reps
        addedExercise.workoutLocation = workoutLocation
        addedExercise.isHIIT = isHIIT
        addedExercise.isStrength = isStrength
        addedExercise.isCardio = isCardio
        addedExercise.isEnabled = isEnabled
        addedExercise.howTo = howTo
        
        context.deleteObject(exerciseToDelete)
        
        appDelegate.saveContext()
        
        return addedExercise
    }
    
    func deleteExercise(#exercise:DefaultExercise) //** delete an exercise from core data **//
    {
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        
        context.deleteObject(exercise)
    }
    
    func addNewExercise(#name:String, weight:Int, workoutType:String, generalBodyLocation:String, specificBodyLocation:String, level1Reps:Int = 20, level2Reps:Int = 40, level3Reps:Int = 60, level4Reps:Int = 80, workoutLocation:String, isHIIT:Bool, isStrength:Bool, isCardio:Bool, isEnabled: Bool) -> Bool //** adds a new exercise to the Default Exercise DB. Checks to make sure that it does not already exist. If it does, notifies the user (return false if error) **//
    {
        var allExercises = self.returnDefaultExerciseArray()
        var isDuplicate = false
        
        for ex in allExercises
        {
            if ex.name == name
            {
                isDuplicate = true
                break
            }
        }
        
        if !isDuplicate
        {
            // add the exercise to Core Data
            //create the new added exercise entity
            let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context:NSManagedObjectContext = appDelegate.managedObjectContext!
            let entityDescription = NSEntityDescription.entityForName("DefaultExercise", inManagedObjectContext: context)
            let addedExercise = DefaultExercise(entity: entityDescription!, insertIntoManagedObjectContext: context)
            
            // set the values for the addedExercise entity
            addedExercise.name = name
            addedExercise.weight = weight
            addedExercise.workoutType = workoutType
            addedExercise.generalBodyLocation = generalBodyLocation
            addedExercise.specificBodyLocation = specificBodyLocation
            addedExercise.level1Reps = level1Reps
            addedExercise.level2Reps = level2Reps
            addedExercise.level3Reps = level3Reps
            addedExercise.level4Reps = level4Reps
            addedExercise.workoutLocation = workoutLocation
            addedExercise.isHIIT = isHIIT
            addedExercise.isStrength = isStrength
            addedExercise.isCardio = isCardio
            addedExercise.isEnabled = isEnabled
            addedExercise.howTo = "N/A"
            
            appDelegate.saveContext()
            return true
        }
        else
        {
            //add alert message telling the user that the exercise already exists
            println("exercise not added")
            return false
        }
    }
    
    func returnDefaultExerciseArray() -> [DefaultExercise] //** Returns an array of the default exercises of type DefaultExercise in alphabetical order **//
    {
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        var exercises:[AnyObject] = context.executeFetchRequest(request, error: nil)!
        
        var exercisesCoreData:[DefaultExercise] = []
        
        for exercise in exercises
        {
            exercisesCoreData.append(exercise as! DefaultExercise)
        }
        
        exercisesCoreData = exercisesCoreData.sorted({ (exOne:DefaultExercise, exTwo:DefaultExercise) -> Bool in
            return exOne.name < exTwo.name
        })
        
        return exercisesCoreData
    }
    
    func returnExerciseReplacement(exercise:WorkoutExercise) -> [DefaultExercise] {
        
        let request = NSFetchRequest(entityName: "DefaultExercise")
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let predicateBodyPart = NSPredicate(format:"specificBodyLocation == %@", exercise.specificBodyLocation)
        request.predicate = predicateBodyPart
        var exercises:[AnyObject] = context.executeFetchRequest(request, error: nil)!
        
        var exercisesCoreData:[DefaultExercise] = []
        
        for exercise in exercises
        {
            exercisesCoreData.append(exercise as! DefaultExercise)
        }
        
        exercisesCoreData = exercisesCoreData.sorted({ (exOne:DefaultExercise, exTwo:DefaultExercise) -> Bool in
            return exOne.name < exTwo.name
        })
        
        return exercisesCoreData
    }
    
    //Fetch Methods for Core Data
    //****** USE LATER MAYBE*****?????
    func exerciseFetchRequest() -> NSFetchRequest
    {
        let fetchRequest = NSFetchRequest(entityName: "DefaultExercise")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController
    {
        var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        fetchedResultsController = NSFetchedResultsController(fetchRequest: self.exerciseFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    func printExerciseDetails(ex:DefaultExercise) {
        println("exercise: \(ex.name)\n weight:\(ex.weight)\n WorkoutType:\(ex.workoutType)\n GeneralBodyLocation:\(ex.generalBodyLocation)\n SpecificBodyLocation:\(ex.specificBodyLocation)\n Workout Location:\(ex.workoutLocation)\n")
    }
    
}






