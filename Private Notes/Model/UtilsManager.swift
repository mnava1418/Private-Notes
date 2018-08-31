//
//  UtilsManager.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 12/08/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import Foundation

class UtilsManager {
    
    /*func getFolderNames() -> [String] {
        let key = "folderNames"
        if let folderNames = UserDefaults.standard.value(forKey: key) as? [String] {
            return folderNames
        } else {
            return []
        }
    }
    
    func createFolder(name: String, docsDir: [String]) -> Void {
        var folderNames = getFolderNames()
        folderNames.append(name)
        
        UserDefaults.standard.set(folderNames, forKey: "folderNames")
        UserDefaults.standard.synchronize()
        
        let file = docsDir[0].appending("\(name).txt")
        print(file)
        let notes:NSArray = NSArray(array: ["Hola\(name)", "Adios\(name)"])
        
        do {
            try notes.write(toFile: file, atomically: true)
            print("Success! Yum.")
        } catch {
            print("Invalid Selection.")
        }
    }
    
    func getNotesByFolderName(folder: String, docsDir: [String]) -> [String] {
        let file = docsDir[0].appending("\(folder).txt")
        if let notesByFolder = NSArray(contentsOfFile: file) as? [String] {
            return notesByFolder
        } else {
            return []
        }
    }
    
    func deleteFolder(folder: String) {
        var folderNames = getFolderNames()
        
        if let folderIndex = folderNames.index(of: folder) {
            folderNames.remove(at: folderIndex)
            
            UserDefaults.standard.set(folderNames, forKey: "folderNames")
            UserDefaults.standard.synchronize()
            
            //let file = docsDir[0].appending(folder)
            //docsDir[0]
        }
    }*/
    
}
