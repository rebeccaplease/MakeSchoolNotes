//
//  ViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        /*
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        let myNote = Note()
        myNote.title   = "Super Simple Test Note"
        myNote.content = "A long piece of content"
        
        //add myNote to Realm database
        let realm = Realm() // 1
        realm.write() { // 2
        realm.add(myNote) // 3
        //for deleting all notes
        realm.deleteAll()
        
        }
        notes = realm.objects(Note)
        */
        
        //load data from Realm
        let realm = Realm()
        super.viewDidLoad()
        tableView.dataSource = self
        
        //sort by date
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        tableView.dataSource = self
        tableView.delegate = self
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
                
            default:
                println("No one loves \(identifier)")
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false) //2 sort loaded data (by date modified)
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

var selectedNote: Note?

extension NotesViewController: UITableViewDelegate {
    
    //selected row? get index
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedNote = notes[indexPath.row]      //1
        //self.performSegueWithIdentifier("ShowExistingNote", sender: self)     //2 segue into newNoteVC
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
