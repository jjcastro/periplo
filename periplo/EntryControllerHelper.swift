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
    func setupTestData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            addTestEntry(title: "A hello from Periplo", text: "#A hello from Periplo ✨\n\nHi! Welcome to Periplo, a crazy simple journaling app. To edit an entry, simply tap the ✏️ on the top right corner, then the 💾 to save. Press 💜 to mark it as a favorite.\n\nYou may notice the editing mode looks a bit different. That's because Periplo uses **Markdown** to make text *pretty and useful*. You can read more about it [here](https://en.wikipedia.org/wiki/Markdown). Tap ✏️ to see how it works:\n\n## Sub-heading\n### Another deeper heading\n \nParagraphs are separated\nby a blank line.\n\nTwo spaces at the end of a line leave a  \nline break.\n\nA [link](http://google.com).\n\nText attributes *italic*, **bold**.\n\nBullet list:\n* apples\n* oranges\n* pears", daysAgo: 3, isFavorite: true)
            
            addTestEntry(title: "Test entry", text: "# Test entry 🛏🛋\n\nI'm convinced that mattress/furniture stores exist in a quantum superposition of grand opening and going out of business sale.\nIt is both and neither at once until an observer records the state at which point it becomes one or the other.\n\nBut because you know exactly where the store is located, you cannot know how fast it is going out of business because of your uncertainty about its business momentum.\n\nAll around us, all the time pairs of anti-discount mattress stores and discount mattress stores are popping into existence, forming the quantum memory foam that is the basis for the universe. Without the pressure of this quantum memory foam strip malls would collapse.\n\nWe can see evidence of this when a pair is created such that one half is within the sales radius of a supermassive furniture store like Ikea-- one of them is pulled in and the other escapes as a Hawking mattress store.", daysAgo: 4, isFavorite: false)
            
            addTestEntry(title: "Another entry", text: "# Another entry 🐶🐕\n\nHere's the thing. You said a \"pupper is a doggo.\" Is it in the same family? **Yes**. No one's arguing that. As someone who is a scientist who studies puppers, doggos, yappers, and even woofers, I am telling you, specifically, in doggology, no one calls puppers doggos. If you want to be \"specific\" like you said, then you shouldn't either. They're not the same thing.\n\nIf you're saying \"doggo family\" you're referring to the taxonomic grouping of Doggodaemous, which includes things from sub woofers to birdos to sharkos (the glub glub kind not the bork bork kind).\n\nSo your reasoning for calling a pupper a doggo is because random people \"call the small yip yip ones doggos?\" Let's get penguos and turkos in there, then, too.\n\nAlso, calling someone a human or an ape? It's not one or the other, that's not how taxonomy works. They're both. A pupper is a pupper and a member of the doggo family. But that's not what you said. You said a pupper is a doggo, which is not true unless you're okay with calling all members of the doggo family doggos, which means you'd call piggos, sluggos, and other species doggos, too. Which you said you don't.\n\nIt's okay to just admit you're wrong, you know?\n\n", daysAgo: 64, isFavorite: true)
            
//            addTestEntry(title: "Yet ANOTHER entry", text: lorem, daysAgo: 94, isFavorite: true)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
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
