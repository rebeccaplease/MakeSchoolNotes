//
//  NotesViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedNote: Note?
    
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() { //called once
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) { //refresh view on each load
        super.viewWillAppear(animated)
        
        //load data from Realm
        let realm = Realm()
        //sort by date
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            println("Identifier \(identifier)")
            
            let realm = Realm()
            switch identifier {
            case "Save":
                let source = segue.sourceViewController as! NewNoteViewController //1 reference to NewNoteVC so can access currentNote
                
                realm.write() {
                    realm.add(source.currentNote!)
                }
                
            case "Delete":
                realm.write() {
                    realm.delete(self.selectedNote!)
                }
                let source = segue.sourceViewController as! NoteDisplayViewController
                source.note = nil; //
                
            default:
                println("No one loves \(identifier)")
            }
            notes = realm.objects(Note).sorted("modificationDate", ascending: false) //2 reload and sort loaded data (by date modified)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController //access note in NoteDisplayVC
            noteViewController.note = selectedNote
        }
    }
    
}


extension NotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
        let row = indexPath.row
        //cell.textLabel?.text = "Hello World"
        
        //cell.titleLabel.text = "Hello"
        //cell.dateLabel.text = "Date"
        
        //using Realm
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 5
        //if nil, return 0
        return Int(notes?.count ?? 0)
    }
    
}

extension NotesViewController: UITableViewDelegate {
    
    //selected row? get index
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedNote = notes[indexPath.row]      //1
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)     //2 segue into newNoteVC
    }
    
    // 3 can edit row?
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 4 edit row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let note = notes[indexPath.row] as Object
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(note)
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        }
    }
    
    
}
