//
//  Workout.swift
//  FitGen
//
//  Created by David Sanders on 4/20/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData

@objc (Workout)
class Workout: NSManagedObject {
    
    @NSManaged var date: NSDate
    @NSManaged var hiitAFAPDict: AnyObject
    @NSManaged var hiitAMREPDict: AnyObject
    @NSManaged var isAFAP: Bool
    @NSManaged var isAMRAP: Bool
    @NSManaged var isComplete: Bool
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var strengthArray: AnyObject
    @NSManaged var superset: Bool
    @NSManaged var supersetArray: AnyObject
    @NSManaged var timeCompleted: String
    @NSManaged var workoutType: String
    @NSManaged var workoutID: NSNumber
    @NSManaged var roundsCompleted: NSNumber
    @NSManaged var score: NSNumber

}
