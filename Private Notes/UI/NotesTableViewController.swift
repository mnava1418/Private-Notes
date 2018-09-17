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
    var action = ""
    var currentNote:Note? = nil
    
    var _fetchedResultsController: NSFetchedResultsController<Note>? = nil
    var fetchedResultsController: NSFetchedResultsController<Note> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
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
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteViewCell
        let note = self.fetchedResultsController.object(at: indexPath)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = .current
        
        let strCurrentDate = dateFormatter.string(from: currentDate)
        var strNoteDate = dateFormatter.string(from: note.date!)
        
        if( strCurrentDate == strNoteDate) {
            dateFormatter.dateFormat = "HH:mm"
            strNoteDate = dateFormatter.string(from: note.date!)
        }
        
        cell.note.text = note.content
        cell.note.textColor = UIColor(named: "Black")

        cell.noteTime.text = strNoteDate
        cell.noteTime.textColor = UIColor(named: "Blue" )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! NoteViewCell
        selectedCell.contentView.backgroundColor = UIColor(named: "Blue")
        selectedCell.note.textColor = UIColor(named: "White")
        selectedCell.noteTime.textColor = UIColor(named: "White" )
        
        let note = self.fetchedResultsController.object(at: indexPath)
        self.action = "updateNote"
        self.currentNote = note
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deSelectedCell = tableView.cellForRow(at: indexPath) as! NoteViewCell
        deSelectedCell.note.textColor = UIColor(named: "Black")
        deSelectedCell.noteTime.textColor = UIColor(named: "Blue" )
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? NoteViewCell {
            cell.note.textColor = UIColor(named: "Black")
            cell.noteTime.textColor = UIColor(named: "Blue" )
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        for i in 0..<self.tableView.numberOfRows(inSection: 0) {
            let currentIndexPath: IndexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: currentIndexPath) as? NoteViewCell {
                cell.note.textColor = UIColor(named: "Black")
                cell.noteTime.textColor = UIColor(named: "Blue" )
            }
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.confirmDeleteNote(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    @objc func addNote() {
        self.action = "addNote"
        self.currentNote = nil
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func confirmDeleteNote(indexPath: IndexPath) {
        let confirmScreen = UIAlertController(title: "Are you sure you want to delete the note?", message: "", preferredStyle: .actionSheet)
        let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
            OperationQueue.main.addOperation {
                self.deleteNote(indexPath: indexPath)
                self.tableView.reloadData()
            }
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmScreen.addAction(deleteAction)
        confirmScreen.addAction(cancelAction)
        
        self.present(confirmScreen, animated: true)
    }
    
    func deleteNote(indexPath: IndexPath) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        let note = self.fetchedResultsController.object(at: indexPath)
        self.managedObjectContext?.delete(note)
        
        do {
            try context.save()
        } catch {}
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let destination = segue.destination as! NoteDetailsViewController
        destination.managedObjectContext = self.managedObjectContext
        destination.fetchedResultsController = self.fetchedResultsController
        destination.selectedFolder = self.selectedFolder
        destination.action = self.action
        destination.currentNote = self.currentNote
    }
}
