//
//  AddExerciseViewController.swift
//  FitGen
//
//  Created by David Sanders on 12/2/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var workoutLocationSegmentControl: UISegmentedControl!
    @IBOutlet weak var generalBodyLocationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var specificBodyLocationPicker: UIPickerView!
    @IBOutlet weak var hiitSwitchLabel: UILabel!
    @IBOutlet weak var hiitSwitch: UISwitch!
    @IBOutlet weak var strengthSwitchLabel: UILabel!
    @IBOutlet weak var strengthSwitch: UISwitch!
    @IBOutlet weak var cardioSwitchLabel: UILabel!
    @IBOutlet weak var cardioSwitch: UISwitch!
    @IBOutlet weak var level1RepsLabel: UILabel!
    @IBOutlet weak var level1RepsTextView: UITextField!
    @IBOutlet weak var level2RepsLabel: UILabel!
    @IBOutlet weak var level2RepsTextView: UITextField!
    @IBOutlet weak var level3RepsLabel: UILabel!
    @IBOutlet weak var level3RepsTextView: UITextField!
    @IBOutlet weak var level4RepsLabel: UILabel!
    @IBOutlet weak var level4RepsTextView: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var levelSlider: UISlider!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var howToTextView: UITextView!
    
    
    let constants = Constants()
    let exerciseFactory = ExerciseFactory()
    var defaultExercise:DefaultExercise?
    
    var specificBodyLocationArray:[String] = []
    var originalFrameY:CGFloat = 0.0
    
    let exerciseDetailsArray = ["Name", "Weight", "Location", "General Body Location", "Specific Body Location", "Exercise Type", "Level Reps", "How-To"]
    
    var name = ""
    var weight:Int = 0
    var workoutLocation = ""
    var generalBodyLocation = ""
    var specificBodyLocation = ""
    var isHIIT = false
    var isStrength = false
    var isCardio = false
    var level1Reps = 0
    var level2Reps = 0
    var level3Reps = 0
    var level4Reps = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.nameTextField.delegate = self
        self.weightTextField.delegate = self
        self.level1RepsTextView.delegate = self
        self.level2RepsTextView.delegate = self
        self.level3RepsTextView.delegate = self
        self.level4RepsTextView.delegate = self
        self.specificBodyLocationPicker.delegate = self
        self.specificBodyLocationPicker.dataSource = self
        
        self.originalFrameY = self.view.frame.origin.y
        
        self.specificBodyLocationArray = [constants.kChest, constants.kBack, constants.kShoulders, constants.kCore, constants.kLegs, constants.kBiceps, constants.kTriceps, constants.kTotal]
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // IF Default Exercise was passed, set everything to the data from the passed default exercise
        if defaultExercise != nil
        {
            
            //Set everything back to its original format
//            self.nameTextField.text = defaultExercise!.name
//            self.nameTextField.enabled = false
//            self.weightTextField.text = "\(defaultExercise!.weight)"
            self.name = defaultExercise!.name
            self.weight = defaultExercise!.weight.integerValue
            
            switch self.defaultExercise!.workoutLocation
            {
            case constants.kGym:
                self.workoutLocationSegmentControl.selectedSegmentIndex = 0
            case constants.kHome:
                self.workoutLocationSegmentControl.selectedSegmentIndex = 1
            default:
                println("default1")
            }
            
            switch self.defaultExercise!.generalBodyLocation
            {
            case constants.kUpper:
                self.generalBodyLocationSegmentedControl.selectedSegmentIndex = 0
            case constants.kLower:
                self.generalBodyLocationSegmentedControl.selectedSegmentIndex = 1
            case constants.kTotal:
                self.generalBodyLocationSegmentedControl.selectedSegmentIndex = 2
            default:
                println("default2")
            }
            
            //indexes correspond to the index of the specific body location array used in the picker. If the array ever changes, this code will have to as well because it is hard coded in
            var test:String = self.defaultExercise!.specificBodyLocation
            switch self.defaultExercise!.specificBodyLocation
            {
            case constants.kChest:
                self.specificBodyLocationPicker.selectRow(0, inComponent: 0, animated: true)
            case constants.kBack:
                self.specificBodyLocationPicker.selectRow(1, inComponent: 0, animated: true)
            case constants.kShoulders:
                self.specificBodyLocationPicker.selectRow(2, inComponent: 0, animated: true)
            case constants.kCore:
                self.specificBodyLocationPicker.selectRow(3, inComponent: 0, animated: true)
            case constants.kLegs:
                self.specificBodyLocationPicker.selectRow(4, inComponent: 0, animated: true)
            case constants.kBiceps:
                self.specificBodyLocationPicker.selectRow(5, inComponent: 0, animated: true)
            case constants.kTriceps:
                self.specificBodyLocationPicker.selectRow(6, inComponent: 0, animated: true)
            case constants.kTotal:
                self.specificBodyLocationPicker.selectRow(7, inComponent: 0, animated: true)
            default:
                println("default3")
            }
            self.hiitSwitch.on = defaultExercise!.isHIIT
            self.strengthSwitch.on = defaultExercise!.isStrength
            self.cardioSwitch.on = defaultExercise!.isCardio
            self.level1RepsTextView.text = "\(defaultExercise!.level1Reps)"
            self.level2RepsTextView.text = "\(defaultExercise!.level2Reps)"
            self.level3RepsTextView.text = "\(defaultExercise!.level3Reps)"
            self.level4RepsTextView.text = "\(defaultExercise!.level4Reps)"
        }
        else
        {
            self.nameTextField.enabled = true
            self.name = "New Exercise"
            self.weight = 0
        }
        
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if self.name != "" && self.name != "New Exercise" {
            if defaultExercise == nil {
                // Execute this section of code if we creating a new exercise and not modifying an existing one
//                self.name = self.nameTextField.text
//                self.weight = self.weightTextField.text.toInt()!
                
                switch self.generalBodyLocationSegmentedControl.selectedSegmentIndex
                {
                case 0:
                    self.generalBodyLocation = constants.kUpper
                case 1:
                    self.generalBodyLocation = constants.kLower
                case 2:
                    self.generalBodyLocation = constants.kTotal
                default:
                    println("default")
                }
                
                switch self.workoutLocationSegmentControl.selectedSegmentIndex
                {
                case 0:
                    self.workoutLocation = constants.kGym
                case 1:
                    self.workoutLocation = constants.kHome
                default:
                    println("default")
                }
                
                self.specificBodyLocation = specificBodyLocationArray[self.specificBodyLocationPicker.selectedRowInComponent(0)]
                
                self.isHIIT = self.hiitSwitch.on
                self.isStrength = self.strengthSwitch.on
                self.isCardio = self.cardioSwitch.on
                
                self.level1Reps = self.level1RepsTextView.text.toInt()!
                self.level2Reps = self.level2RepsTextView.text.toInt()!
                self.level3Reps = self.level3RepsTextView.text.toInt()!
                self.level4Reps = self.level4RepsTextView.text.toInt()!
                
                var saveSuccessful:Bool = self.exerciseFactory.addNewExercise(name: self.name, weight: self.weight, workoutType: self.constants.kHIIT, generalBodyLocation: self.generalBodyLocation, specificBodyLocation: self.specificBodyLocation, level1Reps: self.level1Reps, level2Reps: self.level2Reps, level3Reps: self.level3Reps, level4Reps: self.level4Reps, workoutLocation: self.workoutLocation, isHIIT: self.isHIIT, isStrength: self.isStrength, isCardio: self.isCardio, isEnabled: true)
                
                if saveSuccessful{
                    var alertController = UIAlertController(title: "Success", message: "Exercise saved", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                        })
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
//                    //Set everything back to its original format
//                    self.nameTextField.text = "New Exercise"
//                    self.weightTextField.text = "0"
//                    self.workoutLocationSegmentControl.selectedSegmentIndex = 0
//                    self.generalBodyLocationSegmentedControl.selectedSegmentIndex = 0
//                    self.specificBodyLocationPicker.selectRow(0, inComponent: 0, animated: true)
//                    self.hiitSwitch.on = true
//                    self.strengthSwitch.on = true
//                    self.cardioSwitch.on = true
//                    self.level1RepsTextView.text = "20"
//                    self.level2RepsTextView.text = "40"
//                    self.level3RepsTextView.text = "60"
//                    self.level4RepsTextView.text = "80"
                }
                else
                {
                    var alertController = UIAlertController(title: "Error", message: "Exercise already exists", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                // Execute this section of code if we are modifying a workout instead of creating a new one
                
//                self.name = self.defaultExercise!.name
//                self.weight = self.weightTextField.text.toInt()!
                
                switch self.generalBodyLocationSegmentedControl.selectedSegmentIndex
                {
                case 0:
                    self.generalBodyLocation = constants.kUpper
                case 1:
                    self.generalBodyLocation = constants.kLower
                case 2:
                    self.generalBodyLocation = constants.kTotal
                default:
                    println("default")
                }
                
                switch self.workoutLocationSegmentControl.selectedSegmentIndex
                {
                case 0:
                    self.workoutLocation = constants.kGym
                case 1:
                    self.workoutLocation = constants.kHome
                default:
                    println("default")
                }
                
                self.specificBodyLocation = specificBodyLocationArray[self.specificBodyLocationPicker.selectedRowInComponent(0)]
                
                self.isHIIT = self.hiitSwitch.on
                self.isStrength = self.strengthSwitch.on
                self.isCardio = self.cardioSwitch.on
                
                self.level1Reps = self.level1RepsTextView.text.toInt()!
                self.level2Reps = self.level2RepsTextView.text.toInt()!
                self.level3Reps = self.level3RepsTextView.text.toInt()!
                self.level4Reps = self.level4RepsTextView.text.toInt()!
                let exerciseTemp:DefaultExercise = exerciseFactory.updateExercise(exerciseToDelete: self.defaultExercise!, weight: self.weight, workoutType: self.constants.kHIIT, generalBodyLocation: self.generalBodyLocation, specificBodyLocation: self.specificBodyLocation, level1Reps: self.level1Reps, level2Reps: self.level2Reps, level3Reps: self.level3Reps, level4Reps: self.level4Reps, workoutLocation: self.workoutLocation, isHIIT: self.isHIIT, isStrength: self.isStrength, isCardio: self.isCardio, isEnabled: true, howTo: self.defaultExercise!.howTo)
                self.defaultExercise = exerciseTemp
                var alertController = UIAlertController(title: "Updated", message: "\(self.name) has been updated", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    })
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            var alertController = UIAlertController(title: "Please add a exercise name", message: "The name field is either empty or has New Workout in it. Please Change", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //        if textField != self.nameTextField && textField != self.weightTextField {
        //            self.view.frame = CGRect(x: self.view.frame.origin.x, y: -150, width: self.view.frame.width, height: self.view.frame.height)
        //        }
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: -150, width: self.view.frame.width, height: self.view.frame.height)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.originalFrameY, width: self.view.frame.width, height: self.view.frame.height)
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: IBActions
    
    @IBAction func okButtonTapped(sender: AnyObject) {
        self.reloadData()
    }
    
    @IBAction func increaseButtonPressed(sender: AnyObject) {
        self.levelSlider.value = self.levelSlider.value + 10
        self.sliderValueChanged(UISlider)
    }
    
    @IBAction func decreaseButtonPressed(sender: AnyObject) {
        self.levelSlider.value = self.levelSlider.value - 10
        self.sliderValueChanged(UISlider)
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        let reps = Int(self.levelSlider.value)
        self.level1RepsTextView.text = "\(reps)"
        self.level2RepsTextView.text = "\(reps * 2)"
        self.level3RepsTextView.text = "\(reps * 3)"
        self.level4RepsTextView.text = "\(reps * 4)"
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.originalFrameY, width: self.view.frame.width, height: self.view.frame.height)
        
        //check to make sure that there is anything in the text boxes before resigning. If not, make it zero
        if self.nameTextField.text == "" {
            self.nameTextField.text = "New Exercise"
        }
        if weightTextField.text == "" {
            self.weightTextField.text = "0"
        }
        if self.level1RepsTextView.text == "" {
            self.level1RepsTextView.text = "0"
        }
        if self.level2RepsTextView.text == "" {
            self.level2RepsTextView.text = "0"
        }
        if self.level3RepsTextView.text == "" {
            self.level3RepsTextView.text = "0"
        }
        if self.level4RepsTextView.text == "" {
            self.level4RepsTextView.text = "0"
        }
        self.weightTextField.resignFirstResponder()
        self.level1RepsTextView.resignFirstResponder()
        self.level2RepsTextView.resignFirstResponder()
        self.level3RepsTextView.resignFirstResponder()
        self.level4RepsTextView.resignFirstResponder()
    }
    
    //MARK: Relaod all data in view
    func reloadData() {
        
//        // resign first responder for text fields, and set data to 0 if left blank
//        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.originalFrameY, width: self.view.frame.width, height: self.view.frame.height)
//        
//        //check to make sure that there is anything in the text boxes before resigning. If not, make it zero
//        if self.nameTextField.text == "" {
//            self.nameTextField.text = "New Exercise"
//        }
//        if weightTextField.text == "" {
//            self.weightTextField.text = "0"
//        }
//        if self.level1RepsTextView.text == "" {
//            self.level1RepsTextView.text = "0"
//        }
//        if self.level2RepsTextView.text == "" {
//            self.level2RepsTextView.text = "0"
//        }
//        if self.level3RepsTextView.text == "" {
//            self.level3RepsTextView.text = "0"
//        }
//        if self.level4RepsTextView.text == "" {
//            self.level4RepsTextView.text = "0"
//        }
//        self.nameTextField.resignFirstResponder()
//        self.weightTextField.resignFirstResponder()
//        self.level1RepsTextView.resignFirstResponder()
//        self.level2RepsTextView.resignFirstResponder()
//        self.level3RepsTextView.resignFirstResponder()
//        self.level4RepsTextView.resignFirstResponder()
//        
//        // Set all the data to the information in the UI
//        self.name = self.nameTextField.text
//        self.weight = self.weightTextField.text.toInt()!
        
        switch self.generalBodyLocationSegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.generalBodyLocation = constants.kUpper
        case 1:
            self.generalBodyLocation = constants.kLower
        case 2:
            self.generalBodyLocation = constants.kTotal
        default:
            println("default4")
        }
        
        switch self.workoutLocationSegmentControl.selectedSegmentIndex
        {
        case 0:
            self.workoutLocation = constants.kGym
        case 1:
            self.workoutLocation = constants.kHome
        default:
            println("default5")
        }
        
        self.specificBodyLocation = specificBodyLocationArray[self.specificBodyLocationPicker.selectedRowInComponent(0)]
        
        self.isHIIT = self.hiitSwitch.on
        self.isStrength = self.strengthSwitch.on
        self.isCardio = self.cardioSwitch.on
        
        self.level1Reps = self.level1RepsTextView.text.toInt()!
        self.level2Reps = self.level2RepsTextView.text.toInt()!
        self.level3Reps = self.level3RepsTextView.text.toInt()!
        self.level4Reps = self.level4RepsTextView.text.toInt()!
        
        // Reload the data in the tableview
        
        self.tableview.reloadData()
    }
    
    
    //MARK: PickerView Delegate and DataSources
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.specificBodyLocationArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.specificBodyLocationArray[row]
    }
    
    //MARK: TableView Datasource and Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseDetailsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("addExerciseCell") as! UITableViewCell
        
        cell.textLabel?.text = self.exerciseDetailsArray[indexPath.row]
        var cellDetails:String = ""
        
        var test = indexPath.row
        
        switch indexPath.row {
        case 0:
            cellDetails = self.name
        case 1:
            cellDetails = "\(self.weight)"
        case 2:
            cellDetails = self.workoutLocation
        case 3:
            cellDetails = self.generalBodyLocation
        case 4:
            cellDetails = self.specificBodyLocation
        default:
            println("default6")
        }
        cell.detailTextLabel?.text = cellDetails
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.reloadData()
        switch indexPath.row {
        case 0:
//            self.nameTextField.hidden = false
//            self.weightTextField.hidden = true
//            self.weightLabel.hidden = true
//            self.workoutLocationSegmentControl.hidden = true
//            self.generalBodyLocationSegmentedControl.hidden = true
//            self.specificBodyLocationPicker.hidden = true
//            self.hiitSwitchLabel.hidden = true
//            self.hiitSwitch.hidden = true
//            self.strengthSwitchLabel.hidden = true
//            self.strengthSwitch.hidden = true
//            self.cardioSwitchLabel.hidden = true
//            self.cardioSwitch.hidden = true
//            self.level1RepsLabel.hidden = true
//            self.level1RepsTextView.hidden = true
//            self.level2RepsLabel.hidden = true
//            self.level2RepsTextView.hidden = true
//            self.level3RepsLabel.hidden = true
//            self.level3RepsTextView.hidden = true
//            self.level4RepsLabel.hidden = true
//            self.level4RepsTextView.hidden = true
//            self.levelSlider.hidden = true
//            self.increaseButton.hidden = true
//            self.decreaseButton.hidden = true
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
            if self.defaultExercise == nil {
            let tempName = (self.name == "" ? "New Exercise" : self.name)
            var alertController = UIAlertController(title: "Enter Name", message: "Enter the name of the exercise", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "EX NAME"
                textField.text = ""
                textField.clearButtonMode = UITextFieldViewMode.Always
            }
            
            let textField = alertController.textFields![0] as! UITextField
            
            // Add the action to save the workout in CoreData using the WorkoutFactory Class, passing the workoutTemp object as the parameter
            let saveButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.name = textField.text
                self.tableview.reloadData()
            }
            alertController.addAction(saveButton)
            //-----
            //Add addtional buttons as needed
            //-----
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                if textField.text == "" {
                    self.name = tempName
                    self.tableview.reloadData()
                }
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                var alertController = UIAlertController(title: "Standard Exercise", message: "This is a standard exercise, and the name cannot be changed", preferredStyle: UIAlertControllerStyle.Alert)
                // Add the action to save the workout in CoreData using the WorkoutFactory Class, passing the workoutTemp object as the parameter
                //-----
                //Add addtional buttons as needed
                //-----
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                        self.tableview.reloadData()
                }
                alertController.addAction(okButton)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        case 1:
//            self.nameTextField.hidden = true
//            self.weightTextField.hidden = false
//            self.weightLabel.hidden = false
//            self.workoutLocationSegmentControl.hidden = true
//            self.generalBodyLocationSegmentedControl.hidden = true
//            self.specificBodyLocationPicker.hidden = true
//            self.hiitSwitchLabel.hidden = true
//            self.hiitSwitch.hidden = true
//            self.strengthSwitchLabel.hidden = true
//            self.strengthSwitch.hidden = true
//            self.cardioSwitchLabel.hidden = true
//            self.cardioSwitch.hidden = true
//            self.level1RepsLabel.hidden = true
//            self.level1RepsTextView.hidden = true
//            self.level2RepsLabel.hidden = true
//            self.level2RepsTextView.hidden = true
//            self.level3RepsLabel.hidden = true
//            self.level3RepsTextView.hidden = true
//            self.level4RepsLabel.hidden = true
//            self.level4RepsTextView.hidden = true
//            self.levelSlider.hidden = true
//            self.increaseButton.hidden = true
//            self.decreaseButton.hidden = true
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
            var alertController = UIAlertController(title: "Enter Weight", message: "Enter the weight for the exercise", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "EX WEIGHT"
                textField.text = "\(self.weight)"
                textField.clearButtonMode = UITextFieldViewMode.Always
                textField.keyboardType = UIKeyboardType.NumberPad
            }
            
            let textField = alertController.textFields![0] as! UITextField
            
            // Add the action to save the workout in CoreData using the WorkoutFactory Class, passing the workoutTemp object as the parameter
            let saveButton = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.weight = textField.text.toInt()!
                self.tableview.reloadData()
            }
            alertController.addAction(saveButton)
            //-----
            //Add addtional buttons as needed
            //-----
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
                if textField.text == "" {
                    self.weight = 0
                    self.tableview.reloadData()
                }
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        case 2:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = false
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
        case 3:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = false
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
        case 4:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = false
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
        case 5:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = false
            self.hiitSwitch.hidden = false
            self.strengthSwitchLabel.hidden = false
            self.strengthSwitch.hidden = false
            self.cardioSwitchLabel.hidden = false
            self.cardioSwitch.hidden = false
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = true
        case 6:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = false
            self.level1RepsTextView.hidden = false
            self.level2RepsLabel.hidden = false
            self.level2RepsTextView.hidden = false
            self.level3RepsLabel.hidden = false
            self.level3RepsTextView.hidden = false
            self.level4RepsLabel.hidden = false
            self.level4RepsTextView.hidden = false
            if defaultExercise == nil { //Only show if creating a new exercise
                self.levelSlider.hidden = false
                self.increaseButton.hidden = false
                self.decreaseButton.hidden = false
            }
            self.howToTextView.hidden = true
        case 7:
            self.nameTextField.hidden = true
            self.weightTextField.hidden = true
            self.weightLabel.hidden = true
            self.workoutLocationSegmentControl.hidden = true
            self.generalBodyLocationSegmentedControl.hidden = true
            self.specificBodyLocationPicker.hidden = true
            self.hiitSwitchLabel.hidden = true
            self.hiitSwitch.hidden = true
            self.strengthSwitchLabel.hidden = true
            self.strengthSwitch.hidden = true
            self.cardioSwitchLabel.hidden = true
            self.cardioSwitch.hidden = true
            self.level1RepsLabel.hidden = true
            self.level1RepsTextView.hidden = true
            self.level2RepsLabel.hidden = true
            self.level2RepsTextView.hidden = true
            self.level3RepsLabel.hidden = true
            self.level3RepsTextView.hidden = true
            self.level4RepsLabel.hidden = true
            self.level4RepsTextView.hidden = true
            self.levelSlider.hidden = true
            self.increaseButton.hidden = true
            self.decreaseButton.hidden = true
            self.howToTextView.hidden = false
            if defaultExercise == nil { //Only show if creating a new exercise
                self.howToTextView.text = "Created Exercise: No How-To"
            } else {
                self.howToTextView.text = self.defaultExercise!.howTo.stringByReplacingOccurrencesOfString("\\n\\n", withString: "\n\n", options: nil, range: nil)
            }
        default:
            println("default7")
        }
        
        self.reloadData()
        
    }
}
