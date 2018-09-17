//
//  FoldersTableViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 25/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class FoldersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext? = nil
    var isFolderSelected = false
    var selectedFolder:Folder? = nil
    
    var _fetchedResultsController: NSFetchedResultsController<Folder>? = nil
    var fetchedResultsController: NSFetchedResultsController<Folder> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getNewFolderName))
        self.navigationItem.rightBarButtonItems = [ addButton, editButtonItem]
        
        
        if let indexFolder = UserDefaults.standard.value(forKey: "indexFolder") as? Int
        {
            if indexFolder != -1 {
                let coreDataIndexPath:IndexPath = IndexPath(row: indexFolder, section: 0)
                let folder = self.fetchedResultsController.object(at: coreDataIndexPath)
                self.selectedFolder = folder
                self.isFolderSelected = true
                self.performSegue(withIdentifier: "showNotes", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if( !isFolderSelected ) {
            UserDefaults.standard.set(-1, forKey: "indexFolder")
            UserDefaults.standard.synchronize()
        }
        
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
        let numberOfFolders = self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return numberOfFolders + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! FolderViewCell
        
        if indexPath.row == 0 {
            cell.label.text = "All Notes"
            cell.notesCount.text = String(self.getAllNotesCount())
            cell.notesCount.textColor = UIColor(named: "Blue")
            cell.label.textColor = UIColor(named: "Blue")
            cell.icon.image = UIImage(named: "box60")?.withRenderingMode(.alwaysTemplate)
        } else{
            var coreDataIndexPath: IndexPath = indexPath
            coreDataIndexPath.row = indexPath.row - 1
            
            let folder = self.fetchedResultsController.object(at: coreDataIndexPath)
            var notesCount = 0
            
            if let folderNotes = folder.notes {
                notesCount = folderNotes.allObjects.count
            }
            
            cell.label.text = folder.name
            cell.notesCount.text = String(notesCount)
            cell.notesCount.textColor = UIColor(named: "Black")
            cell.label.textColor = UIColor(named: "Black")
            cell.label.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.icon.image = UIImage(named: "folder60")?.withRenderingMode(.alwaysTemplate)
        }
        
        cell.icon.tintColor = UIColor(named: "Blue")
        cell.forward.image = UIImage(named: "forward60")?.withRenderingMode(.alwaysTemplate)
        cell.forward.tintColor = UIColor(named: "Blue")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! FolderViewCell
        selectedCell.contentView.backgroundColor = UIColor(named: "Blue")
        selectedCell.label.textColor = UIColor(named: "White")
        selectedCell.notesCount.textColor = UIColor(named: "White")
        selectedCell.icon.tintColor = UIColor(named: "White")
        selectedCell.forward.tintColor = UIColor(named: "White")
        
        if(indexPath.row == 0) {
            return
        }else{
            var coreDataIndexPath = indexPath
            coreDataIndexPath.row = indexPath.row - 1
            
            UserDefaults.standard.set(coreDataIndexPath.row, forKey: "indexFolder")
            UserDefaults.standard.synchronize()
            
            let folder = self.fetchedResultsController.object(at: coreDataIndexPath)
            self.isFolderSelected = true
            self.selectedFolder = folder
            self.performSegue(withIdentifier: "showNotes", sender: nil)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deSelectedCell = tableView.cellForRow(at: indexPath) as! FolderViewCell
        deSelectedCell.icon.tintColor = UIColor(named: "Blue")
        deSelectedCell.forward.tintColor = UIColor(named: "Blue")
        
        if indexPath.row == 0 {
            deSelectedCell.label.textColor = UIColor(named: "Blue")
            deSelectedCell.notesCount.textColor = UIColor(named: "Blue")
            
        } else{
            deSelectedCell.label.textColor = UIColor(named: "Black")
            deSelectedCell.notesCount.textColor = UIColor(named: "Black")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? FolderViewCell {
            cell.icon.tintColor = UIColor(named: "Blue")
            cell.forward.tintColor = UIColor(named: "Blue")
            
            if indexPath.row == 0 {
                cell.label.textColor = UIColor(named: "Blue")
                cell.notesCount.textColor = UIColor(named: "Blue")
            } else{
                cell.label.textColor = UIColor(named: "Black")
                cell.notesCount.textColor = UIColor(named: "Black")
            }
        }
        
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        for i in 0..<self.tableView.numberOfRows(inSection: 0) {
            
            let currentIndexPath: IndexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: currentIndexPath) as? FolderViewCell {
                cell.icon.tintColor = UIColor(named: "Blue")
                cell.forward.tintColor = UIColor(named: "Blue")
                
                if currentIndexPath.row == 0 {
                    cell.label.textColor = UIColor(named: "Blue")
                    cell.notesCount.textColor = UIColor(named: "Blue")
                } else{
                    cell.label.textColor = UIColor(named: "Black")
                    cell.notesCount.textColor = UIColor(named: "Black")
                }
            }
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.confirmDeleteFolder(indexPath: indexPath)
        }
        
        let updateAction = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            self.getUpdatedFolderName(indexPath: indexPath)
        }
        updateAction.backgroundColor = UIColor(named: "Blue")
        
        return [deleteAction, updateAction]
    }
    
    //MARK: Customize Methods
    
    func addFolder(newName: String) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        var name = newName
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name == "" || self.isExistingFolder(folderName: name) {
            return
        }
        
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context ) as! Folder
        folder.name = name
        
        do {
            try context.save()
        } catch {}
        
        let indexPath = self.fetchedResultsController.indexPath(forObject: folder)
        
        for i in 0..<self.tableView.numberOfRows(inSection: 0) {
            self.tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
        }
        
        var tableIndexPath = indexPath
        tableIndexPath!.row = indexPath!.row + 1
        
        self.tableView.insertRows(at: [tableIndexPath!], with: .middle)
    }
    
    func updateFolder(coreDataIndexPath: IndexPath, name:String) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        var newName = name
        newName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newName == "" || self.isExistingFolder(folderName: newName) {
            return
        }
        
        let folder = self.fetchedResultsController.object(at: coreDataIndexPath)
        folder.name = newName

        do {
            try context.save()
        } catch {}
        
        self.tableView.reloadData()
    }
    
    @objc func getNewFolderName() {
        if tableView.isEditing {
            return
        }
        
        let newFolderScreen = UIAlertController(title: "New Folder", message: "Enter folder name", preferredStyle: .alert)
        
        newFolderScreen.addTextField { (name: UITextField) in
            name.placeholder = "Folder Name"
            name.autocapitalizationType = .words
        }
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            if let name = newFolderScreen.textFields![0].text{
                OperationQueue.main.addOperation {
                    self.addFolder(newName: name)
                }
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        newFolderScreen.addAction(saveAction)
        newFolderScreen.addAction(cancelAction)
        
        self.present(newFolderScreen, animated: true)
    }
    
    func getUpdatedFolderName(indexPath: IndexPath) {
        var coreDataIndexPath: IndexPath = indexPath
        coreDataIndexPath.row = indexPath.row - 1
        
        let updateFolderScreen = UIAlertController(title: "Update Folder", message: "Enter folder name", preferredStyle: .alert)
        
        updateFolderScreen.addTextField { (newName: UITextField) in
            newName.placeholder = "Folder Name"
            newName.autocapitalizationType = .words
        }
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            if let newName = updateFolderScreen.textFields![0].text{
                OperationQueue.main.addOperation {
                    self.updateFolder(coreDataIndexPath: coreDataIndexPath, name: newName)
                }
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        updateFolderScreen.addAction(saveAction)
        updateFolderScreen.addAction(cancelAction)
        
        self.present(updateFolderScreen, animated: true)
    }
    
    func deleteFolder(coreDataIndexPath: IndexPath, indexPath: IndexPath) {
        guard let context = self.managedObjectContext else {
            return
        }
        
        let folder = self.fetchedResultsController.object(at: coreDataIndexPath)
        self.managedObjectContext?.delete(folder)
         
         do {
            try context.save()
         } catch {}
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func confirmDeleteFolder(indexPath: IndexPath) {
        var coreDataIndexPath: IndexPath = indexPath
        coreDataIndexPath.row = indexPath.row - 1
        let folder  = self.fetchedResultsController.object(at: coreDataIndexPath)
        var notesCount = 0
        
        if let folderNotes = folder.notes {
            notesCount = folderNotes.allObjects.count
        }
        
        if notesCount > 0 {
            let confirmScreen = UIAlertController(title: "Are you sure?", message: "All notes in \(folder.name!) will be deleted", preferredStyle: .actionSheet)
            let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                OperationQueue.main.addOperation {
                    self.deleteFolder(coreDataIndexPath: coreDataIndexPath, indexPath: indexPath)
                    self.tableView.reloadData()
                }
            }
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            confirmScreen.addAction(deleteAction)
            confirmScreen.addAction(cancelAction)
            
            self.present(confirmScreen, animated: true)
        } else {
            self.deleteFolder(coreDataIndexPath: coreDataIndexPath, indexPath: indexPath)
            self.tableView.reloadData()
        }
    }
    
    func isExistingFolder(folderName: String) -> Bool {
        let predicate = NSPredicate(format: "name == %@", folderName )
        self.fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try self.fetchedResultsController.performFetch()
            let numberOfFolders = self.fetchedResultsController.sections?[0].numberOfObjects ?? 0
            self.fetchedResultsController.fetchRequest.predicate = nil
            try self.fetchedResultsController.performFetch()
            
            if numberOfFolders > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return true
        }
    }
    
    func getAllNotesCount() -> Int {
        var allNotesCount = 0
        let numberOfFolders = self.fetchedResultsController.sections?[0].numberOfObjects ?? 0
        
        for i in 0..<numberOfFolders {
            let coreDataIndexPath = IndexPath(row: i, section: 0)
            let currenFolder = self.fetchedResultsController.object(at: coreDataIndexPath)
            
            if let folderNotes = currenFolder.notes {
                allNotesCount += folderNotes.allObjects.count
            }
        }
        
        return allNotesCount
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let destination = segue.destination as! NotesTableViewController
        destination.selectedFolder = self.selectedFolder
        destination.managedObjectContext = self.managedObjectContext
        destination.folderViewController = self
    }
}
