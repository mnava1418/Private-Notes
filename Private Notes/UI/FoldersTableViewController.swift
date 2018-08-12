//
//  FoldersTableViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 25/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {

    let notesManager = NotesManager()
    var folders:[String] = []
    var notesByFolder:[String: [String]] = [:]
    var allNotes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNotesInfo()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getNewFolderName))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! FolderViewCell
        cell.label.text = folders[indexPath.row]
        
        if indexPath.row == 0 {
            cell.notesCount.text = String(allNotes.count)
            cell.notesCount.textColor = UIColor(named: "Blue")
            cell.label.textColor = UIColor(named: "Blue")
            cell.icon.image = UIImage(named: "box60")?.withRenderingMode(.alwaysTemplate)
        } else{
            let folder = folders[indexPath.row]
            var currentNotesCount = 0
            
            if let currentNotes = notesByFolder[folder] {
                currentNotesCount = currentNotes.count
            }
            
            cell.notesCount.text = String(currentNotesCount)
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
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.confirmDeleteFolder(folderName: self.folders[indexPath.row], indexPath: indexPath)
        }
        
        /*let updateAction = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            self.getUpdatedFolderName(oldName: self.folders[indexPath.row] )
        }
        updateAction.backgroundColor = UIColor(named: "Blue")*/
        
        return [deleteAction]
    }
    
    //MARK: Customize Methods
    
    func addFolder(name: String) {
        if name != ""{
            if let indexFolder = folders.index(of: name){
                if indexFolder >= 0 {
                    return
                }
            }
            
            notesManager.addFolder(name: name)
            getNotesInfo()
            
            let indexFolder = notesManager.getFolderIndex(folders: folders, folderName: name)
            let indexPath = IndexPath(row: indexFolder, section: 0)
            tableView.insertRows(at: [indexPath], with: .middle)
            //tableView.reloadData()
        }
    }
    
    /*func updateFolder(oldName:String, newName:String) {
        /*if newName != ""{
            if let indexFolder = folders.index(of: newName){
                if indexFolder >= 0 {
                    return
                }
            }
            
            notesManager.updateFolder(oldName: oldName, newName: newName)
            getNotesInfo()
            tableView.reloadData()
        }*/
    }*/
    
    @objc func getNewFolderName() {
        if tableView.isEditing {
            return
        }
        
        let newFolderScreen = UIAlertController(title: "New Folder", message: "Enter folder name", preferredStyle: .alert)
        
        newFolderScreen.addTextField { (name: UITextField) in
            name.placeholder = "Folder Name"
        }
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            if let name = newFolderScreen.textFields![0].text{
                OperationQueue.main.addOperation {
                    self.addFolder(name: name)
                }
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        newFolderScreen.addAction(saveAction)
        newFolderScreen.addAction(cancelAction)
        
        self.present(newFolderScreen, animated: true)
    }
    /*
    func getUpdatedFolderName(oldName: String) {
        /*let updateFolderScreen = UIAlertController(title: "Update Folder", message: "Enter folder name", preferredStyle: .alert)
        
        updateFolderScreen.addTextField { (newName: UITextField) in
            newName.placeholder = "Folder Name"
        }
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction) in
            if let newName = updateFolderScreen.textFields![0].text{
                OperationQueue.main.addOperation {
                    self.updateFolder(oldName: oldName, newName: newName)
                }
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        updateFolderScreen.addAction(saveAction)
        updateFolderScreen.addAction(cancelAction)
        
        self.present(updateFolderScreen, animated: true)*/
    }*/
    
    func deleteFolder(folderName: String, indexPath: IndexPath)
    {
        notesManager.removeFolder(folder: folderName)
        getNotesInfo()
        
        let headerIndexPath = IndexPath(row: 0, section: 0)
        let headerCell = tableView.cellForRow(at: headerIndexPath) as! FolderViewCell
        headerCell.notesCount.text = String(self.allNotes.count)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func confirmDeleteFolder(folderName: String, indexPath: IndexPath) {
        let notes = Array(notesByFolder[folderName]!)
        
        if folders.count <= 2 {
            let blockScreen = UIAlertController(title: "At least one folder must exit.", message: "", preferredStyle: .alert)
            let okAction:UIAlertAction = UIAlertAction(title: "Ok", style: .default )
            
            blockScreen.addAction(okAction)
            self.present(blockScreen, animated: true)
        }else {
            if notes.count > 0 {
                let confirmScreen = UIAlertController(title: "Are you sure?", message: "All notes in \"\(folderName) \"will be deleted", preferredStyle: .actionSheet)
                let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                    OperationQueue.main.addOperation {
                        self.deleteFolder(folderName: folderName, indexPath: indexPath)
                    }
                }
                let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                confirmScreen.addAction(deleteAction)
                confirmScreen.addAction(cancelAction)
                
                self.present(confirmScreen, animated: true)
            } else {
                self.deleteFolder(folderName: folderName, indexPath: indexPath)
            }
        }
    }
    
    func getNotesInfo() {
        folders = notesManager.getFolders()
        notesByFolder = notesManager.getNotesByFolderName(folderNames: folders)
        allNotes = notesManager.getAllNotes()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
