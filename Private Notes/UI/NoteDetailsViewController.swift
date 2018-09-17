//
//  NoteDetailsViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 26/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var noteContent: UITextView!
    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchedResultsController: NSFetchedResultsController<Note>? = nil
    var selectedFolder:Folder? = nil
    var action = ""
    var currentNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = currentNote {
            self.noteContent.text = note.content
        }
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = doneButton
        
        if(self.action == "addNote")
        {
            noteContent.becomeFirstResponder()
        }else {
            noteContent.resignFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote") {
                self.addNote( content: content.text)
            } else {
                if(self.action == "updateNote") {
                    self.updateNote(content: content.text)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func addNote(content: String) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.folder = self.selectedFolder
        note.content = content
        note.date = Date()
        
        do {
            try context.save()
        } catch {}
    }
    
    func updateNote(content: String) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        if let note = self.currentNote {
            note.content = content
            note.date = Date()
            
            do {
                try context.save()
            } catch {}
        }
    }
    
    @objc func doneEditing() {
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote") {
                self.addNote( content: content.text)
                let indexPath: IndexPath = IndexPath(row: 0, section: 0)
                
                do {
                    try self.fetchedResultsController?.performFetch()
                } catch {}
                
                self.currentNote = self.fetchedResultsController?.object(at: indexPath)
                self.action = "updateNote"
            } else {
                if(self.action == "updateNote") {
                    self.updateNote(content: content.text)
                }
            }
            noteContent.resignFirstResponder()
        }
    }
}
