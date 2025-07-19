//
//  TabBarViewController.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var mainCoordinator: MainCoordinator?
    private var locationsCoordinator: LocationsCoordinator?
    
    override func viewDidLoad() {
        let mainNavController = UINavigationController()
        let locationNavController = UINavigationController()
        
        mainCoordinator = MainCoordinator(navigationController: mainNavController)
        locationsCoordinator = LocationsCoordinator(navigationController: locationNavController)
        
        mainNavController.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        locationNavController.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "map"),
            tag: 1
        )
        
        mainCoordinator?.start()
        locationsCoordinator?.start()
        viewControllers = [
            mainNavController,
            locationNavController
        ]
    }
}
