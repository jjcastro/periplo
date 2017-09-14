//
//  SettingsController.swift
//  periplo
//
//  Created by Juan José Castro on 8/17/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    let items = ["About", "Open Source"]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.rgb(0, 89, 246)
        self.navigationController?.view.backgroundColor = .white
//        navigationController?.navigationBar.isTranslucent = false
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "GENERAL"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold)
        headerLabel.textColor = UIColor(red:0.45, green:0.46, blue:0.47, alpha:0.75)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        headerView.addConstraintsWithFormat("V:[v0]-|", views: headerLabel)
        headerView.addConstraintsWithFormat("H:|-16-[v0]", views: headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let controller = AboutController()
                navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller = OpenSourceController()
                navigationController?.pushViewController(controller, animated: true)
            default: break
            }
        default: break
        }
        
        
    }
}
