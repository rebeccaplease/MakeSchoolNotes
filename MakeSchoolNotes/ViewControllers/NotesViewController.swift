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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        let myNote = Note()
        myNote.title   = "Super Simple Test Note"
        myNote.content = "A long piece of content"
        
        //add myNote to Realm database on each run
        let realm = Realm() // 1
        realm.write() { // 2
            realm.add(myNote) // 3
            //for deleting all notes
            //realm.deleteAll()
        }
        notes = realm.objects(Note)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
