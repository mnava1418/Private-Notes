//
//  Note+CoreDataProperties.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 20/11/18.
//  Copyright © 2018 mnava. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var binaryContent: NSAttributedString?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var folder: Folder?

}
