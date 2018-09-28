//
//  NoteDetailsViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 26/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextViewDelegate {

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
        
        if(self.action == "addNote" && self.selectedFolder != nil)
        {
            noteContent.becomeFirstResponder()
        }else {
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(confirmDeleteNote))
            self.navigationItem.rightBarButtonItem = deleteButton
            noteContent.resignFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.doneEditing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(confirmDeleteNote))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    func addNote(content: String) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        if self.selectedFolder == nil {
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
    
    @objc func confirmDeleteNote() {
        if self.currentNote != nil {
            let confirmScreen = UIAlertController(title: "Are you sure you want to delete the note?", message: "", preferredStyle: .actionSheet)
            let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                OperationQueue.main.addOperation {
                    self.deleteNote()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            confirmScreen.addAction(deleteAction)
            confirmScreen.addAction(cancelAction)
            
            self.present(confirmScreen, animated: true)
        }
    }
    
    func deleteNote() {
        guard let context = self.managedObjectContext else {
            return
        }
        
        context.delete(self.currentNote!)
        
        do {
            try context.save()
        } catch {}
        
        self.action = ""
        self.currentNote = nil
    }
    
    @objc func doneEditing() {
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote" && self.selectedFolder != nil) {
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
    
    @objc func willResignActive() {
        self.doneEditing()
    }
}
