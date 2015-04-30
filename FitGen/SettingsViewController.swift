//
//  SettingsViewController.swToday markst
//  FitGen
//
//  Created by David Sanders on 4/16/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var settingsList = ["Restore Default Exercises", "Set Time Limit", "Set Units", "Auto Stop Timer", "About"]
    let exerciseFactory = ExerciseFactory()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    //MARK: Change details message box
    //
    //    func changeMyWorkoutDetails() {
    //        var alertController = UIAlertController(title: "My Workout Details", message: "What details do you want to see on your workout list?", preferredStyle: UIAlertControllerStyle.Alert)
    //        var defaults = NSUserDefaults.standardUserDefaults()
    //        alertController.addAction(UIAlertAction(title: "Show Date", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    //            defaults.setObject(kMyDate, forKey: kMyDetailsChoice)
    //        }))
    //
    //        alertController.addAction(UIAlertAction(title: "Show Type", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    //            defaults.setObject(kMyType, forKey: kMyDetailsChoice)
    //        }))
    //        alertController.addAction(UIAlertAction(title: "Show Completed", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    //            defaults.setObject(kMyCompleted, forKey: kMyDetailsChoice)
    //        }))
    //        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
    //        self.presentViewController(alertController, animated: true, completion: nil)
    //    }
    
    func setTimeLimit() {
        var alertController = UIAlertController(title: "Set Time Limit", message: "Set the time limit for the HIIT workouts. Timer will stop when set time is reached.", preferredStyle: UIAlertControllerStyle.Alert)
        var defaults = NSUserDefaults.standardUserDefaults()
        alertController.addAction(UIAlertAction(title: "15 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(15, forKey: kTimeLimit)
            self.tableView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "20 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(20, forKey: kTimeLimit)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "25 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(25, forKey: kTimeLimit)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "30 min", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(30, forKey: kTimeLimit)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "No Time Limit", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            defaults.setObject(-1, forKey: kTimeLimit)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel!.text = self.settingsList[indexPath.row]
        let defaults = NSUserDefaults.standardUserDefaults()
        switch indexPath.row {
        case 1:
            if defaults.objectForKey(kTimeLimit) as! Int == -1 {
                cell.detailTextLabel!.text = "Unlimited"
            } else {
                cell.detailTextLabel!.text = "\(defaults.objectForKey(kTimeLimit) as! Int)"
            }
        case 2:
            cell.detailTextLabel!.text = (defaults.objectForKey(kUnits) as? String)?.uppercaseString
        case 3:
            cell.detailTextLabel!.text = (defaults.boolForKey(kRoundStopTime)) ? "TRUE" : "FALSE"
        default:
            cell.detailTextLabel!.text = ""
        }
        
        //cell.detailTextLabel!.text = (indexPath.row == 2) ? defaults.objectForKey(kUnits) as! String : ""
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            var alertController = UIAlertController(title: "Reload Default Exercises", message: "Reloading exercises cannot be undone. Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            var defaults = NSUserDefaults.standardUserDefaults()
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.exerciseFactory.loadDefaultExercises()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        case 1:
            self.setTimeLimit()
        case 2:
            var alertController = UIAlertController(title: "Select Units", message: "Select metric or standard units.", preferredStyle: UIAlertControllerStyle.Alert)
            var defaults = NSUserDefaults.standardUserDefaults()
            alertController.addAction(UIAlertAction(title: "Metric", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(kMetric, forKey: kUnits)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Standard", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setObject(kStandard, forKey: kUnits)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        case 3:
            var alertController = UIAlertController(title: "Auto Stop Timer", message: "Do you want to stop the timer when rounds are complete?", preferredStyle: UIAlertControllerStyle.Alert)
            var defaults = NSUserDefaults.standardUserDefaults()
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setBool(true, forKey: kRoundStopTime)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                defaults.setBool(false, forKey: kRoundStopTime)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        case 4:
            performSegueWithIdentifier("toAboutSegue", sender: nil)
        default:
            println("tableview switch default")
        }
        self.tableView.reloadData()
    }
    
}
