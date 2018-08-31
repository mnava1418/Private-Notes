//
//  NotesManager.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 25/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import Foundation

class NotesManager {
    
    /*private var notesByFolder:[String: [String]]
    private let utilManager:UtilsManager
    public var docsDir:[String]*/
    
    init() {
        /*self.utilManager = UtilsManager()
        self.notesByFolder = [String: [String]]()
        self.docsDir = []*/
    }
    
    /*func getNotesByFolderName(folderNames: [String]) -> [String: [String]] {
        for folder in folderNames {
            self.notesByFolder[folder] = utilManager.getNotesByFolderName(folder: folder, docsDir: docsDir)
        }
     
        return self.notesByFolder
    }
    
    func getFolders() -> [String] {
        var allFolders = ["All Notes"]
        var folderNames = utilManager.getFolderNames()
        
        if folderNames.count == 0 {
            utilManager.createFolder(name: "Notes", docsDir: docsDir)
            folderNames = utilManager.getFolderNames()
        }
        
        folderNames.sort()
        allFolders += folderNames
        
        return allFolders
    }
    
    func getAllNotes() -> [String] {
        var allNotes:[String] = []
        let folders = self.notesByFolder.keys
        
        for folder in folders {
            if let notes = self.notesByFolder[folder] {
                allNotes += notes
            }
        }
        
        return allNotes
    }
    
    func getFolderIndex(folders: [String], folderName:String)-> Int {
        if let folderIndex = folders.index(of: folderName) {
            return folderIndex
        } else {
            return folders.count - 1
        }
    }
    
    func addFolder(name: String) {
        utilManager.createFolder(name: name, docsDir: docsDir)
    }
    
    func removeFolder(folder: String) {
        notesByFolder.removeValue(forKey: folder)
        utilManager.deleteFolder(folder: folder)
    }*/
    
    /*func updateFolder(oldName: String, newName:String) {
        /*if let tempNotes = notesByFolder[oldName] {
            removeFolder(name: oldName)
            notesByFolder[newName] = tempNotes
        } else {
            addFolder(name: newName)
        }*/
    }*/
}
