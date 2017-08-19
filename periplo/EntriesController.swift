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

class EntriesController: UITableViewController, SwipeTableViewCellDelegate, NSFetchedResultsControllerDelegate {

    private let cellId = "cellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)
        ]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "groupByMonth", cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    var whiteTrashImage: UIImage? = {
        let image = #imageLiteral(resourceName: "trash").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white
        return imageView.image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.rgb(0, 89, 246)
        
        navigationItem.title = "Entries"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.register(EntryCell.self, forCellReuseIdentifier: cellId)
        
        tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            setupTestData()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        loadData()
        setupNavBarButtons()
    }
    
    private func setupNavBarButtons() {
        let editBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-new"), style: .plain, target: self, action: #selector(createNewNote))
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        navigationItem.rightBarButtonItems = [negativeSpacer, editBarButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func createNewNote() {
        let entry = Entry(context: fetchedResultsController.managedObjectContext)
        entry.text = "# New entry title\n\nPress ✏️ to begin writing!"
        entry.date = Date()
        entry.isFavorite = false
        
        do {
            try entry.managedObjectContext?.save()
            let controller = SingleEntryController()
            controller.entry = entry
            navigationController?.pushViewController(controller, animated: true)
        } catch {
            let saveError = error as NSError
            print("Unable to Save Note")
            print("\(saveError), \(saveError.localizedDescription)")
        }
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let favoriteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let entry = self.fetchedResultsController.object(at: indexPath)
            entry.isFavorite = !(entry.isFavorite?.boolValue)! as NSNumber
        }
        
        favoriteAction.backgroundColor = UIColor.rgb(255, 94, 255)
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            action.fulfill(with: .delete)
            self.tableView(self.tableView, commit: .delete, forRowAt: indexPath)
        }
        deleteAction.image = whiteTrashImage
        deleteAction.backgroundColor = UIColor.rgb(233, 26, 0)
        
        return [deleteAction]
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
        label.layer.borderColor = UIColor.rgb(230, 230, 230).cgColor;
        label.layer.borderWidth = 1.0;
        return label
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entry = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(entry)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! SwipeTableViewCell
            cell.hideSwipe(animated: true) { (completion: Bool) in
                self.tableView.reloadRows(at: [indexPath!], with: .fade)
            }
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        if(indexPath.row == totalRow - 1){
            (cell as! EntryCell).separatorView.isHidden = true
        }
    }
}
