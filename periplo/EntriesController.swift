//
//  ViewController.swift
//  periplo
//
//  Created by Juan José Castro on 7/19/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class EntriesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    
    var entries: [Entry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "periplo ✎"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EntryCell
        
        if let entry = entries?[indexPath.item] {
            cell.entry = entry
            
            if indexPath.item == 0 {
                cell.timelineViewTop.isHidden = true
            }
            if indexPath.item == entries!.count - 1 {
                cell.timelineViewBtm.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SingleEntryController()
        controller.entry = entries?[indexPath.item]
        navigationController?.pushViewController(controller, animated: true)
    }
}
