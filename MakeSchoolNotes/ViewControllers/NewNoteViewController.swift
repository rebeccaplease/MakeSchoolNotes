//
//  NewNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Rebecca Poch on 6/23/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    //declare variable
    var currentNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //instantiate currentNote when button is pressed
        currentNote = Note()
        //add dummy title and content
        currentNote!.title = "testing"
        currentNote!.content = "hello everyone"
    }
    

}
