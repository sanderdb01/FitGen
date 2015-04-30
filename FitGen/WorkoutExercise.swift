//
//  WorkoutExercise.swift
//  FitGen
//
//  Created by David Sanders on 11/29/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import Foundation

class WorkoutExercise: NSObject, NSCoding {
    
    var name: String = ""                   // Name of the exercise
    var date: NSDate = NSDate()             // Date the exercise was created
    var workoutType: String = ""            // Equal to strength, HIIT, or cardio
    var specificBodyLocation: String = ""   // Equal to the specific body location
    var generalBodyLocation: String = ""    // Equal to Total, Upper, or Lower
    var superset: NSNumber = 0              // Which superset is it in. If 0, then is not part of superset
    var weight: AnyObject = []              // Array where value is number for the weight, and index is the set
    var reps: AnyObject = []                // Array where value is number for reps, and index is the set.
    var howTo:String = ""
    
    init (name:String, date:NSDate, workoutType:String, specificBodyLocation:String, generalBodyLocation:String, superset:Int, weight:[Int], reps:[Int], howTo:String)
    {
        super.init()
        self.name = name
        self.date = date
        self.workoutType = workoutType
        self.specificBodyLocation = specificBodyLocation
        self.generalBodyLocation = generalBodyLocation
        self.superset = superset
        self.weight = weight
        self.reps = reps
        self.howTo = howTo
    }

    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
        self.workoutType = aDecoder.decodeObjectForKey("workoutType") as! String
        self.specificBodyLocation = aDecoder.decodeObjectForKey("specificBodyLocation") as! String
        self.generalBodyLocation = aDecoder.decodeObjectForKey("generalBodyLocation") as! String
        self.superset = aDecoder.decodeObjectForKey("superset") as! NSNumber
        self.weight = aDecoder.decodeObjectForKey("weight") as! NSArray
        self.reps = aDecoder.decodeObjectForKey("reps") as! NSArray
        self.howTo = aDecoder.decodeObjectForKey("howTo") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.workoutType, forKey: "workoutType")
        aCoder.encodeObject(self.specificBodyLocation, forKey: "specificBodyLocation")
        aCoder.encodeObject(self.generalBodyLocation, forKey: "generalBodyLocation")
        aCoder.encodeObject(self.superset, forKey: "superset")
        aCoder.encodeObject(self.weight, forKey: "weight")
        aCoder.encodeObject(self.reps, forKey: "reps")
        aCoder.encodeObject(self.howTo, forKey: "howTo")
    }
    
}