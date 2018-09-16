//
//  NoteDetailsViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 26/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController {

    @IBOutlet weak var noteContent: UITextView!
    var managedObjectContext: NSManagedObjectContext? = nil
    var selectedFolder:Folder? = nil
    var action = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote") {
                self.addNote( content: content.text)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        self.action = "update"
    }
    
    @objc func doneEditing() {
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote") {
                self.addNote( content: content.text)
            }
        }
    }
}
