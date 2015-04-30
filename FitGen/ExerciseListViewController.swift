//
//  ExerciseListViewController.swift
//  FitGen
//
//  Created by David Sanders on 12/2/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var exerciseList:[DefaultExercise]!
    var exerciseFactory = ExerciseFactory()
    
    @IBOutlet weak var exerciseListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        exerciseList = exerciseFactory.returnDefaultExerciseArray()
        println("test")
    }
    
    override func viewDidAppear(animated: Bool) {
        self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData()
    {
        //reload the exerciseList with the latest data and reloads the tableView
        exerciseList = exerciseFactory.returnDefaultExerciseArray()
        self.exerciseListTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exerciseListToAdd"{
            let AddVC:AddExerciseViewController = segue.destinationViewController as! AddExerciseViewController
            
            if sender != nil
            {
                AddVC.defaultExercise = sender! as? DefaultExercise
            }
        }
    }
    
    @IBAction func addExerciseBarButtonTapped(sender: AnyObject) {
        
        performSegueWithIdentifier("exerciseListToAdd", sender: nil)
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exerciseList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseListCell") as! ExerciseListTableViewCell
        var exercise:DefaultExercise = exerciseList[indexPath.row] as DefaultExercise
        cell.nameLabel?.text = exercise.name
        cell.detailsLabel?.text = exercise.specificBodyLocation
        cell.defaultExercise = exercise
        cell.enabledSwitch.on = exercise.isEnabled
        cell.listVC = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var exercise:DefaultExercise = exerciseList[indexPath.row] as DefaultExercise
        self.exerciseFactory.printExerciseDetails(exercise)
        performSegueWithIdentifier("exerciseListToAdd", sender: exercise)
    }
    
   func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            var name = self.exerciseList[indexPath.row].name
            self.exerciseFactory.deleteExercise(exercise: self.exerciseList[indexPath.row])
            self.exerciseList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            var alertController = UIAlertController(title: "Deleted", message: "\(name) has been deleted", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        self.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        self.exerciseListTableView.setEditing(editing, animated: animated)
    }

}
