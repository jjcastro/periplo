//
//  ViewController.swift
//  periplo
//
//  Created by Juan José Castro on 7/19/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class EntriesController: UITableViewController, SwipeTableViewCellDelegate {

    private let cellId = "cellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)
        ]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "groupByMonth", cacheName: nil)
//        controller.delegate = self
        return controller
    }()
    
    var whiteHeartImage: UIImage? = {
        let heartImage = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: heartImage)
        imageView.tintColor = UIColor.white
        return imageView.image
    }()
    
    var whiteBrokenHeartImage: UIImage? = {
        let heartImage = #imageLiteral(resourceName: "heart-broken").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: heartImage)
        imageView.tintColor = UIColor.white
        return imageView.image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "periplo ✎"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.register(EntryCell.self, forCellReuseIdentifier: cellId)
        
        setupData()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EntryCell
        cell.delegate = self
        
        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry
        
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
        if (indexPath.row == lastRowIndex - 1 && indexPath.section == tableView.numberOfSections - 1) {
            cell.timelineViewBtm.isHidden = true
        }
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.timelineViewTop.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let favoriteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let cell = tableView.cellForRow(at: indexPath) as! EntryCell
            if let entry = cell.entry {

                entry.isFavorite = !(entry.isFavorite?.boolValue)! as NSNumber
                cell.entry = entry
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! EntryCell
        if let entry = cell.entry {
            if entry.isFavorite == true {
                favoriteAction.image = whiteBrokenHeartImage
            } else {
                
            }
        }
        favoriteAction.backgroundColor = UIColor.magenta
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            print(self.tableView(self.tableView, numberOfRowsInSection: indexPath.section))
            
            let entry = self.fetchedResultsController.object(at: indexPath)
            self.fetchedResultsController.managedObjectContext.delete(entry)
            
            self.loadData()
            
            print(self.tableView(self.tableView, numberOfRowsInSection: indexPath.section))
            
            self.tableView.beginUpdates()
            
            action.fulfill(with: .delete)
            self.tableView.endUpdates()

            
        }
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, favoriteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SingleEntryController()
        let entry = fetchedResultsController.object(at: indexPath)
        controller.entry = entry
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name.uppercased()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textAlignment = .center
        label.backgroundColor = UIColor.rgb(247, 247, 247)
        return label
    }
}
