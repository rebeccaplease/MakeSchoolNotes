//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Rebecca Poch on 6/24/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ConvenienceKit

class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: TextView! //from ConvienienceKit
    
    var edit:Bool = false
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    override func viewWillAppear(animated: Bool) { //called each time before init (refresh)
        super.viewWillAppear(animated)
        
        displayNote(note)
        
        titleTextField.returnKeyType = .Next //rename return to Next
        titleTextField.delegate = self //set delegate of type UITextFieldDelegate (implemented as class extension)
        
    }
    
    //MARK: Business Logic
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView  {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if(count(note.title) == 0 && count(note.content) == 0) { //check for content in title and text field
                titleTextField.becomeFirstResponder() //title field is highlighted when creating a new note
            }
        }
    }
    
    //when press back button, save note
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let note = note {
            let realm = Realm()
            
            realm.write {
                if(note.title != self.titleTextField.text || note.content != self.contentTextView.textValue) {
                    note.title = self.titleTextField.text
                note.content = self.contentTextView.textValue
                    note.modificationDate = NSDate()
                }
            }
            
        }
        
    }
}

extension NoteDisplayViewController: UITextFieldDelegate {
    
    //called when Next is pressed (from title)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == titleTextField) { //if highlighted text field is titleTextField
            contentTextView.returnKeyType = .Done //change return to Done
            contentTextView.becomeFirstResponder() //returns true
        }
        return false
    }
}
