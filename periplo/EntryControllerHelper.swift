//
//  Entry.swift
//  periplo
//
//  Created by Juan José Castro on 7/21/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import CoreData

extension EntriesController {
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let lorem = "#Entry Title\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur"
            
            addTestEntry(title: "entry test title", text: lorem, daysAgo: 3, isFavorite: true)
            
            addTestEntry(title: "another entry test title", text: lorem, daysAgo: 4, isFavorite: false)
            
            addTestEntry(title: "yet another entry test title", text: lorem, daysAgo: 64, isFavorite: true)
            
            addTestEntry(title: "yet another old entry title", text: lorem, daysAgo: 94, isFavorite: true)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        
//        loadData()
    }
    
    func addTestEntry(title: String, text: String, daysAgo: Int, isFavorite: Bool) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry
            entry.text = text
            entry.date = Date().addingTimeInterval(TimeInterval(daysAgo * 60 * 60 * 24 * -1))
            entry.isFavorite = NSNumber(value: isFavorite)
        }
    }
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let fetch: NSFetchRequest<NSFetchRequestResult> = Entry.fetchRequest()
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try context.execute(request)
            } catch let err {
                print(err)
            }
        }
    }
}
