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
        
        folders = notesManager.getFolders()
        notesByFolder = notesManager.getNotesByFolder()
        allNotes = notesManager.getAllNotes()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
