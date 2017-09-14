//
//  ViewController.swift
//  periplo
//
//  Created by Juan José Castro on 7/19/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit
import CoreData

class EntriesController: UITableViewController, NSFetchedResultsControllerDelegate {

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
//        view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)]
        } else {
            // Fallback on earlier versions
        }
//        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.rgb(0, 89, 246)
        self.navigationController?.view.backgroundColor = .white
        
        navigationItem.title = "Entries"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)]
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
        navigationItem.rightBarButtonItems = [editBarButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func createNewNote() {
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
//        cell.delegate = self
        
        let entry = fetchedResultsController.object(at: indexPath)
        cell.entry = entry
        
        return cell
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
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
        textView.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.rgb(247, 247, 247)
        textView.layer.borderColor = UIColor.rgb(230, 230, 230).cgColor
        textView.layer.borderWidth = 1.0
        textView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.isUserInteractionEnabled = false
        return textView
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
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
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
