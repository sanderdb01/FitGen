//
//  AddExerciseToStrengthTableViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/26/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

protocol AddExerciseToStrengthTableViewControllerDelegate {
    func passBackExercise(exercise:WorkoutExercise)
}

class AddExerciseToStrengthTableViewController: UITableViewController {
    
    var exerciseArray:[DefaultExercise] = []
    var exerciseFactory = ExerciseFactory()
    
    var delegate:AddExerciseToStrengthTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.exerciseArray = exerciseFactory.returnDefaultExerciseArray()
        let backgroundImage = UIImageView(image: UIImage(named: "FGBackground2.png"))
        self.tableView.backgroundView = backgroundImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.exerciseArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addExerciseToStrengthCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = self.exerciseArray[indexPath.row].name
        cell.detailTextLabel?.text = self.exerciseArray[indexPath.row].specificBodyLocation

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ex = self.exerciseArray[indexPath.row] as DefaultExercise                                   
        let exercise:WorkoutExercise = WorkoutExercise(name: ex.name, date: Date.getCurrentDate(), workoutType: ex.workoutType, specificBodyLocation: ex.specificBodyLocation, generalBodyLocation: ex.generalBodyLocation, superset: 0, weight: [ex.weight.integerValue, ex.weight.integerValue, ex.weight.integerValue], reps: [10,10,10], howTo: ex.howTo)
        self.delegate!.passBackExercise(exercise)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
