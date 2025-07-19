//
//  AccountCoordinator.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

/// Example child coordinator that takes data via dependency injection.
class AccountCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start(user: User) {
        let vc = AccountViewController(user: user)
        vc.accountCoordinator = self
        vc.title = user.name
        navigationController.pushViewController(vc, animated: true)
    }
}
