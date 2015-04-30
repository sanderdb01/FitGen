//
//  ExerciseListTableViewCell.swift
//  FitGen
//
//  Created by David Sanders on 12/3/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class ExerciseListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var defaultExercise:DefaultExercise!
    var exerciseFactory = ExerciseFactory()
    var listVC:ExerciseListViewController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func enabledSwitchChanged(sender: AnyObject) {
        var isEnabled = self.enabledSwitch.on
        self.exerciseFactory.updateExercise(exerciseToDelete: self.defaultExercise, weight: self.defaultExercise.weight, workoutType: self.defaultExercise.workoutType, generalBodyLocation: self.defaultExercise.generalBodyLocation, specificBodyLocation: self.defaultExercise.specificBodyLocation, level1Reps: Int(self.defaultExercise.level1Reps), level2Reps: Int(self.defaultExercise.level2Reps), level3Reps: Int(self.defaultExercise.level3Reps), level4Reps: Int(self.defaultExercise.level4Reps), workoutLocation: self.defaultExercise.workoutLocation, isHIIT: self.defaultExercise.isHIIT, isStrength: self.defaultExercise.isStrength, isCardio: self.defaultExercise.isCardio, isEnabled: isEnabled, howTo: self.defaultExercise.howTo)
        listVC.reloadData()
    }
}
