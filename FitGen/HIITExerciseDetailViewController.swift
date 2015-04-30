//
//  HIITExerciseDetailViewController.swift
//  FitGen
//
//  Created by David Sanders on 3/23/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class HIITExerciseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exercise:WorkoutExercise?

    @IBOutlet weak var tableView: UITableView!
    
    var name: String = ""                   // Name of the exercise
    //var date: NSDate = NSDate()             // Date the exercise was created
    var workoutType: String = ""            // Equal to strength, HIIT, or cardio
    var specificBodyLocation: String = ""   // Equal to the specific body location
    var generalBodyLocation: String = ""    // Equal to Total, Upper, or Lower
    //var superset: NSNumber = 0              // Which superset is it in. If 0, then is not part of superset
    var weight: AnyObject = []              // Array where value is number for the weight, and index is the set
    var reps: AnyObject = []                // Array where value is number for reps, and index is the set.
    
    var items = 7                           //number of listed items above, plue 1 for the how-to page
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        println("\(self.exercise!.name)")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.name = self.exercise!.name
        self.workoutType = self.exercise!.workoutType
        self.generalBodyLocation = self.exercise!.generalBodyLocation
        self.specificBodyLocation = self.exercise!.specificBodyLocation
        self.weight = self.exercise!.weight[0]
        self.reps = self.exercise!.reps[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toHowToSegue" {
            var howToSegue = segue.destinationViewController as! HowToViewController
            howToSegue.exerciseWE = self.exercise
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("hiitExDetailCell") as! UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = "\(self.name)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 1:
            cell.textLabel?.text = "Workout Type"
            cell.detailTextLabel?.text = "\(self.workoutType)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 2:
            cell.textLabel?.text = "General"
            cell.detailTextLabel?.text = "\(self.generalBodyLocation)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 3:
            cell.textLabel?.text = "Specific"
            cell.detailTextLabel?.text = "\(self.specificBodyLocation)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 4:
            cell.textLabel?.text = "Weight"
            cell.detailTextLabel?.text = "\(self.weight)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 5:
            cell.textLabel?.text = "Reps"
            cell.detailTextLabel?.text = "\(self.reps)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        case 6:
            cell.textLabel?.text = "How-To"
            cell.detailTextLabel?.text = ""
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        default:
            println("tableview switch statement default")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
            performSegueWithIdentifier("toHowToSegue", sender: nil)
        }
    }

}
