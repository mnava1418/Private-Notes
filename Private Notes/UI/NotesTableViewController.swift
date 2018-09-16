//
//  NotesTableViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 01/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var selectedFolder:Folder? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var folderViewController:FoldersTableViewController!
    var recalculateData = false
    var action = ""
    
    var _fetchedResultsController: NSFetchedResultsController<Note>? = nil
    var fetchedResultsController: NSFetchedResultsController<Note> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let currentFolder = selectedFolder {
            let predicate = NSPredicate(format: "folder == %@", currentFolder)
            fetchRequest.predicate = predicate
        }
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {}
        
        return _fetchedResultsController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentFolder = selectedFolder {
            self.title = currentFolder.name
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItems = [ addButton, editButtonItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        folderViewController.isFolderSelected = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(recalculateData) {
            recalculateData = false
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteViewCell
        let note = self.fetchedResultsController.object(at: indexPath)
        cell.note.text = note.content
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    @objc func addNote() {
        self.action = "addNote"
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let destination = segue.destination as! NoteDetailsViewController
        destination.notesViewController = self
        destination.managedObjectContext = self.managedObjectContext
        destination.selectedFolder = self.selectedFolder
        destination.action = self.action
    }
}
