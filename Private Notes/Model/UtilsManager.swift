//
//  UtilsManager.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 12/08/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import Foundation

class UtilsManager {
    
    func getFolderNames() -> [String] {
        let key = "folderNames"
        if let folderNames = UserDefaults.standard.value(forKey: key) as? [String] {
            return folderNames
        } else {
            return []
        }
    }
    
    func createFolder(name: String) -> Void {
        var folderNames = getFolderNames()
        folderNames.append(name)
        
        UserDefaults.standard.set(folderNames, forKey: "folderNames")
        UserDefaults.standard.set(["Hola"], forKey: name)
        UserDefaults.standard.synchronize()
    }
    
    func getNotesByFolderName(folder: String) -> [String] {
        if let notesByFolder = UserDefaults.standard.value(forKey: folder) as? [String] {
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
            UserDefaults.standard.removeObject(forKey: folder)
            UserDefaults.standard.synchronize()
        }
    }
    
}
