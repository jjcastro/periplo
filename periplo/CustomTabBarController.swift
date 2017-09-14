//
//  CustomTabBarController.swift
//  periplo
//
//  Created by Juan José Castro on 7/24/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.tintColor = UIColor.rgb(0, 89, 246)
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
        
        let homeController = UINavigationController(rootViewController: EntriesController())
        homeController.tabBarItem.title = "Entries"
        homeController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.heavy)], for: .normal)
        homeController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        homeController.tabBarItem.image = #imageLiteral(resourceName: "home")
        homeController.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
//        let timelineCtrl = UIViewController()
//        timelineCtrl.tabBarItem.title = "Timeline"
//        timelineCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
//        timelineCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
//        timelineCtrl.tabBarItem.image = #imageLiteral(resourceName: "timeline")
//        timelineCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
//        
//        let insightsCtrl = UIViewController()
//        insightsCtrl.tabBarItem.title = "Insights"
//        insightsCtrl.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)], for: .normal)
//        insightsCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
//        insightsCtrl.tabBarItem.image = #imageLiteral(resourceName: "atom")
//        insightsCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        let settingsCtrl = UINavigationController(rootViewController: SettingsController())
        settingsCtrl.tabBarItem.title = "Settings"
        settingsCtrl.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.heavy)], for: .normal)
        settingsCtrl.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3)
        settingsCtrl.tabBarItem.image = #imageLiteral(resourceName: "profile")
        settingsCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0)
        
        viewControllers = [homeController, settingsCtrl]
    }
}
