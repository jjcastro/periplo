//
//  Entry+CoreDataProperties.swift
//  periplo
//
//  Created by Juan José Castro on 9/14/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isFavorite: NSNumber?
    @NSManaged public var text: String?
    
    @objc public var groupByMonth: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            return dateFormatter.string(from: self.date!)
        }
    }

}
