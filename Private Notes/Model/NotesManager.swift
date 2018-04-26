//
//  NotesManager.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 25/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import Foundation

class NotesManager {
    
    private var notesByFolder:[String: [String]]
    
    init() {
        self.notesByFolder = [String: [String]]()
        notesByFolder["Folder 3"] = ["Note 3 a","Note 3 b","Note 3 c"]
        notesByFolder["Folder 1"] = ["Note 1 a"]
        notesByFolder["Folder 2"] = ["Note 2 a", "Note 2 b"]
        notesByFolder["Folder 4"] = []
    }
    
    func getNotesByFolder() -> [String: [String]] {
        return notesByFolder
    }
    
    func getFolders() -> [String] {
        var folders = ["All Notes"]
        var keys = Array(notesByFolder.keys)
        
        if keys.count > 0 {
            keys.sort()
            folders += keys
        }
        
        return folders
    }
    
    func getAllNotes() -> [String] {
        var allNotes:[String] = []
        let folders = notesByFolder.keys
        
        for folder in folders {
            if let notes = notesByFolder[folder] {
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
        notesByFolder[name] = []
    }
}
