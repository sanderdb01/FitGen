//
//  StrengthExerciseDetailViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/13/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

protocol StrengthExerciseDetailViewControllerDelegate {
    func passEditedExercise(#reps:[Int], weight:[Int], indexPath:NSIndexPath)
    func cancelEdit()
}

class StrengthExerciseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exercise:WorkoutExercise!   //Exercise passed into the view from the generated workout view
    var indexPath:NSIndexPath!      //Index of the exercise chosen from the previous view
    var reps:[Int] = []             //reps array from the passed exercise object
    var weight:[Int] = []           // weight array from the passed exercise object
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:StrengthExerciseDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.reps = self.exercise.reps as! Array
        self.weight = self.exercise.weight as! Array
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: IBButton Actions
    
    //save the changes to the exercise and dismiss the view
    @IBAction func saveButtonPressed(sender: AnyObject) {
        self.delegate?.passEditedExercise(reps: self.reps, weight: self.weight, indexPath: self.indexPath)
        println("pressed")
    }
    
    //Cancel button pressed so no changes are saved
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.delegate?.cancelEdit()
    }
    
    @IBAction func addBarButtonPressed(sender: AnyObject) {
        self.reps.append(10)
        self.weight.append(135)
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView Delegate and Data Source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var repsUnit = ""
        var reps = "\(self.reps[indexPath.row])"
        switch exercise.name {
        case "running":
            repsUnit = " m"
            reps = (defaults.objectForKey(kUnits) as! String == kMetric) ? "\(reps) \(kMeterUnits)" : "\(ConvertUnits.metersToMiles(reps.toInt()!)) \(kMileUnits))"
        case "planks":
            repsUnit = " sec"
        default:
            repsUnit = ""
        }
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("strengthDetailCell") as! UITableViewCell
        //cell.textLabel?.text = "Set \(indexPath.row + 1)-> Weight: \(self.weight[indexPath.row])  Reps: \(self.reps[indexPath.row])"
        cell.textLabel?.text = "Set \(indexPath.row + 1)-> Weight: \(self.weight[indexPath.row])  Reps: \(reps)\(repsUnit)"
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //When the cell is tapped, a message box comes up with the option to chance the values for the weight and the reps
        var alertController = UIAlertController(title: "Edit Exercise", message: "Edit the reps and weight for the set.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (weightTextField) in
            weightTextField.placeholder = "WEIGHT"
            weightTextField.text = "\(self.weight[indexPath.row])"
            weightTextField.keyboardType = UIKeyboardType.NumberPad
        }
        alertController.addTextFieldWithConfigurationHandler { (repsTextField) in
            repsTextField.placeholder = "REPS"
            repsTextField.text = "\(self.reps[indexPath.row])"
            repsTextField.keyboardType = UIKeyboardType.NumberPad
        }
        
        let weightTextField = alertController.textFields![0] as! UITextField
        let repsTextField = alertController.textFields![1] as! UITextField
        
        // Add the action to pass the edited exercise back to the view. The values are not saved yet
        let saveWorkoutAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            if weightTextField.text == "" {
                weightTextField.text = "0"
            }
            if repsTextField.text == "" {
                repsTextField.text = "0"
            }
            self.weight[indexPath.row] = weightTextField.text.toInt()!
            //*** code to convert, but buggy right now. fix later
            //self.reps[indexPath.row] = (defaults.objectForKey(kUnits) as! String == kMetric) ? repsTextField.text.toInt()! : (ConvertUnits.milesToMeters(repsTextField.text.toInt()!)).toInt()!
            self.reps[indexPath.row] = repsTextField.text.toInt()!
            tableView.reloadData()
        }
        alertController.addAction(saveWorkoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            var oldWeight = self.weight[indexPath.row]
            var oldReps = self.reps[indexPath.row]
            self.reps.removeAtIndex(indexPath.row)
            self.weight.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            var alertController = UIAlertController(title: "Deleted", message: "Set \(indexPath.row + 1): Weight = \(oldWeight) Reps = \(oldReps) has been deleted.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        self.tableView.setEditing(editing, animated: animated)
    }

}
