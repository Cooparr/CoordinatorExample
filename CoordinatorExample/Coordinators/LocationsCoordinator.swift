//
//  LocationsCoordinator.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

class LocationsCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        /// Can do some navigation controller customization during init
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController.navigationBar.standardAppearance = appearance
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    
    func start() {
        navigationController.delegate = self
        let vc = LocationsViewController()
        vc.locationCoordinator = self
        vc.title = "Locations VC"
        navigationController.pushViewController(vc, animated: false)
    }
}
