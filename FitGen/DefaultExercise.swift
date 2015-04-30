//
//  DefaultExercise.swift
//  FitGen
//
//  Created by David Sanders on 4/14/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData

@objc (DefaultExercise)
class DefaultExercise: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var weight: NSNumber
    @NSManaged var workoutType: String
    @NSManaged var generalBodyLocation: String
    @NSManaged var specificBodyLocation: String
    @NSManaged var level1Reps: NSNumber
    @NSManaged var level2Reps: NSNumber
    @NSManaged var level3Reps: NSNumber
    @NSManaged var level4Reps: NSNumber
    @NSManaged var workoutLocation: String
    @NSManaged var isHIIT: Bool
    @NSManaged var isCardio: Bool
    @NSManaged var isStrength: Bool
    @NSManaged var isEnabled: Bool
    @NSManaged var howTo: String

}
