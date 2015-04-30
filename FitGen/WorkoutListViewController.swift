//
//  WorkoutListViewController.swift
//  FitGen
//
//  Created by David Sanders on 12/3/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class WorkoutListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SavedHIITWorkoutViewControllerDelegate, SavedStrengthWorkoutViewControllerDelegate {
    
    @IBOutlet weak var workoutListTableView: UITableView!
    
    var workoutList:[Workout]!
    let workoutFactory = WorkoutFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadData()
    }
    
    func reloadData()
    {
        self.workoutList = self.workoutFactory.returnWorkoutArray()
        self.workoutListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "workoutListToHIIT" {
            if sender is NSIndexPath {
                let indexPath = sender as! NSIndexPath
                let savedHIITVC = segue.destinationViewController as! SavedHIITWorkoutViewController
                savedHIITVC.workout = self.workoutList[indexPath.row]
                savedHIITVC.delegate = self
            }
        }
        if segue.identifier == "workoutListToStrength" {
            if sender is NSIndexPath {
                let indexPath = sender as! NSIndexPath
                let savedStrengthVC = segue.destinationViewController as! SavedStrengthWorkoutViewController
                savedStrengthVC.workout = self.workoutList[indexPath.row]
                savedStrengthVC.delegate = self
            }
            
        }
    }
    
    //MARK: IBActions
    
    @IBAction func detailInfoButtonPressed(sender: AnyObject) {
        var alertController = UIAlertController(title: "My Workout Details", message: "What details do you want to see on your workout list?", preferredStyle: UIAlertControllerStyle.Alert)
        var defaults = NSUserDefaults.standardUserDefaults()
        alertController.addAction(UIAlertAction(title: "Show Date", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(kMyDate, forKey: kMyDetailsChoice)
            self.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Show Type", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(kMyType, forKey: kMyDetailsChoice)
            self.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Show Completed", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(kMyCompleted, forKey: kMyDetailsChoice)
            self.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: VC Delegate functions
    
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutListCell") as! UITableViewCell
        var name = self.workoutList[indexPath.row].name
        
        //***Truncate the string so that it does not overflow. Add to other tables later
        if count(name) > 18 {
            name = name.substringToIndex(advance(name.startIndex, 19)) + "..."
            println("\(name)")
        }
        cell.textLabel?.text = name
        let defaults = NSUserDefaults.standardUserDefaults()
        switch defaults.objectForKey(kMyDetailsChoice) as! String{
        case kMyDate:
            cell.detailTextLabel?.text = Date.toString(date: self.workoutList[indexPath.row].date)
        case kMyCompleted:
            cell.detailTextLabel?.text = self.workoutList[indexPath.row].isComplete ? "Completed" : "Not Completed"
        case kMyType:
            cell.detailTextLabel?.text = self.workoutList[indexPath.row].workoutType
        default:
            println("tableview text detail default")
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var workout:Workout = self.workoutList[indexPath.row] as Workout
        
        if workout.isAMRAP || workout.isAFAP {
            //var strengthArray:[String] = workout.strengthArray as [String]
            self.performSegueWithIdentifier("workoutListToHIIT", sender: indexPath)
        }
        else {
            self.performSegueWithIdentifier("workoutListToStrength", sender: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            var name = self.workoutList[indexPath.row].name
            self.workoutFactory.deleteWorkout(workout: self.workoutList[indexPath.row])
            self.workoutList.removeAtIndex(indexPath.row)
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
        self.workoutListTableView.setEditing(editing, animated: animated)
    }
    
}
