//
//  CustomTabBarController.swift
//  periplo
//
//  Created by Juan José Castro on 7/24/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.blue
        tabBar.barTintColor = UIColor.white
        
        let homeController = UINavigationController(rootViewController: EntriesController())
        homeController.tabBarItem.title = "Entries"
        homeController.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
        homeController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        homeController.tabBarItem.image = #imageLiteral(resourceName: "home")
        homeController.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        let timelineCtrl = UIViewController()
        timelineCtrl.tabBarItem.title = "Timeline"
        timelineCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
        timelineCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        timelineCtrl.tabBarItem.image = #imageLiteral(resourceName: "timeline")
        timelineCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        let addEntryCtrl = UIViewController()
        addEntryCtrl.tabBarItem.title = "Add Entry"
        addEntryCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
        addEntryCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        addEntryCtrl.tabBarItem.image = #imageLiteral(resourceName: "timeline")
        addEntryCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        let insightsCtrl = UIViewController()
        insightsCtrl.tabBarItem.title = "Insights"
        insightsCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
        insightsCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        insightsCtrl.tabBarItem.image = #imageLiteral(resourceName: "timeline")
        insightsCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        let settingsCtrl = UIViewController()
        settingsCtrl.tabBarItem.title = "Settings"
        settingsCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
        settingsCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        settingsCtrl.tabBarItem.image = #imageLiteral(resourceName: "timeline")
        settingsCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        viewControllers = [homeController, timelineCtrl, addEntryCtrl, insightsCtrl, settingsCtrl]
    }
    
    let kBarHeight = 80.0;
    
//    override func viewWillLayoutSubviews() {
//        var tabFrame = self.tabBar.frame
//        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.size.height = 60
//        tabFrame.origin.y = self.view.frame.size.height - 60
//        self.tabBar.frame = tabFrame
//    }
    

}
