//
//  WorkoutNotesViewController.swift
//  FitGen
//
//  Created by David Sanders on 1/30/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

protocol WorkoutNotesViewControllerDelegate {
    func saveNotes (notes:String)
}

class WorkoutNotesViewController: UIViewController {

    //var titleLabel:UILabel!
    //var textView:UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    var delegate:WorkoutNotesViewControllerDelegate!
    var notes:String = ""
    var isEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.titleLabel = UILabel(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.width, 50))
        //self.titleLabel.text = "NOTES"
        //self.view.addSubview(self.titleLabel)
        
        self.title = "NOTES"
        self.notesTextView.text = self.notes
        if self.isEdit {
            var saveButton:UIBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveBarButtonItemPressed:"))
            self.navigationItem.rightBarButtonItem = saveButton
            self.notesTextView.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveBarButtonItemPressed (barButtonItem: UIBarButtonItem) {
        if self.notesTextView.text == nil {
            self.notesTextView.text = ""
        }
        self.notes = self.notesTextView.text
        self.delegate.saveNotes(self.notes)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
