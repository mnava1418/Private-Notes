//
//  Note.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 20/11/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import CoreData

class Note: NSManagedObject  {
    @NSManaged var content: NSAttributedString?
    @NSManaged var date: Date?
}
