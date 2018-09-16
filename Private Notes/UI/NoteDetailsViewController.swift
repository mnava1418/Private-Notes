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
    var notesViewController: NotesTableViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var selectedFolder:Folder? = nil
    var action = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainViewController = appDelegate.window?.rootViewController as! UISplitViewController
        self.navigationItem.rightBarButtonItem = mainViewController.displayModeButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let content = noteContent {
            if(content.text.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return
            }
            
            if(self.action == "addNote") {
                self.addNote( content: content.text)
                notesViewController?.recalculateData = true
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
    }
}
