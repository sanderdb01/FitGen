//
//  DefaultExercise.swift
//  FitGen
//
//  Created by David Sanders on 4/14/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData

class DefaultExercise: NSManagedObject {

    @NSManaged var generalBodyLocation: String
    @NSManaged var isCardio: NSNumber
    @NSManaged var isEnabled: NSNumber
    @NSManaged var isHIIT: NSNumber
    @NSManaged var isStrength: NSNumber
    @NSManaged var level1Reps: NSNumber
    @NSManaged var level2Reps: NSNumber
    @NSManaged var level3Reps: NSNumber
    @NSManaged var level4Reps: NSNumber
    @NSManaged var name: String
    @NSManaged var specificBodyLocation: String
    @NSManaged var weight: NSNumber
    @NSManaged var workoutLocation: String
    @NSManaged var workoutType: String
    @NSManaged var howTo: String

}
