//
//  WorkoutTemp.swift
//  FitGen
//
//  Created by David Sanders on 12/1/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import Foundation
import CoreData

@objc (WorkoutTemp)
class WorkoutTemp: NSObject {
    
    var date: NSDate = NSDate()
    var hiitAFAPDict: AnyObject = [:]
    var hiitAMREPDict: AnyObject = [:]
    var isAFAP: Bool = false
    var isAMRAP: Bool = false
    var isComplete: Bool = false
    var name: String = ""
    var strengthArray: AnyObject = []
    var superset: Bool = false
    var supersetArray: AnyObject = []
    var timeCompleted: String = ""
    var workoutType: String = ""
    var notes: String = ""
    var numberOfRounds: NSNumber = 0
    var roundsCompleted: NSNumber = 0
    var workoutID = 0
    var score = 0
    
}