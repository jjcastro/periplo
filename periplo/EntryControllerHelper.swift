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
            
            addTestEntry(title: "closure (or, emotional maturity)", preview: "at this point, i feel like maybe there IS such a thing as emotional maturity.today, in the eve of my last week in Seattle, i sit here and wonder about all the", daysAgo: 3, isFavorite: true)
            
            addTestEntry(title: "closure (or, emotional maturity)", preview: "at this point, i feel like maybe there IS such a thing as emotional maturity.today, in the eve of my last week in Seattle, i sit here and wonder about all the", daysAgo: 4, isFavorite: false)
            
            addTestEntry(title: "closure (or, emotional maturity)", preview: "at this point, i feel like maybe there IS such a thing as emotional maturity.today, in the eve of my last week in Seattle, i sit here and wonder about all the", daysAgo: 64, isFavorite: true)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    func addTestEntry(title: String, preview: String, daysAgo: Int, isFavorite: Bool) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry
            entry.title = "closure (or, emotional maturity)"
            entry.preview = "at this point, i feel like maybe there IS such a thing as emotional maturity.today, in the eve of my last week in Seattle, i sit here and wonder about all the"
            entry.date = Date().addingTimeInterval(TimeInterval(daysAgo * 60 * 60 * 24 * -1))
            entry.isFavorite = NSNumber(value: isFavorite)
        }
    }
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
            do {
                entries = try context.fetch(fetchRequest) as? [Entry]
                for entry in entries! {
                    context.delete(entry)
                }
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                entries = try context.fetch(fetchRequest) as? [Entry]

            } catch let err {
                print(err)
            }
        }
    }
    

}
