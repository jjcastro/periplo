//
//  SingleEntryController.swift
//  periplo
//
//  Created by Juan José Castro on 7/23/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class SingleEntryController: UIViewController {
    
    var entry: Entry? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            navigationItem.title = formatter.string(from: entry!.date!)
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
    }
    
}
