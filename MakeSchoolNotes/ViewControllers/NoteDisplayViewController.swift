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
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    override func viewWillAppear(animated: Bool) { //called each time before init (refresh)
        super.viewWillAppear(animated)
        
        displayNote(note)
    }
    
    //MARK: Business Logic
    
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView  {
            titleTextField.text = note.title
            contentTextView.text = note.content
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
