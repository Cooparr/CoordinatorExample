//
//  MainCoordinator.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        /// Can do some navigation controller customization during init
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController.navigationBar.standardAppearance = appearance
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    
    func start() {
        navigationController.delegate = self
        let vc = MainViewController()
        vc.mainCoordinator = self
        vc.title = "Main VC"
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    /// Example of how MainCoordinator would handle navigating between two VCs
    func showDetailViewController() {
        let vc = DetailViewController()
        vc.mainCoordinator = self
        vc.title = "Some Detail VC"
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    /// Example of MainCoordinator creating a child coordinator and using it for navigation
    func showAccount() {
        /// Imagine we are getting this from somewhere properly
        let currentUser = getCurrentUser()
        
        /// This demonstrates how to create a child coordinator and pass data.
        let child = AccountCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(user: currentUser)
        print("👤 AccountCoordinator taking over")
    }
    
    
    /// Example of MainCoordinator presenting another VC, in this case a bottom sheet
    func presentSomeBottomSheet() {
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.mainCoordinator = self
        
        // Configure for bottom sheet presentation
        bottomSheetViewController.modalPresentationStyle = .pageSheet
        
        // Configure the sheet (iOS 15+)
        if let sheet = bottomSheetViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
        }
        
        navigationController.present(bottomSheetViewController, animated: true)
    }
    
    
    /// The purpose of childDidFinish(_:) is memory management - it removes child coordinators from the childCoordinators array when they're no longer needed, preventing memory leaks.
    /// Otherwise when we create a child coordinator and add it to childCoordinators it would stay there forever!
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            /// Identity comparison (same object reference)
            if coordinator === child {
                let coordinatorName = String(describing: type(of: coordinator))
                print("🗑️ Removing child coordinator: \(coordinatorName)")
                childCoordinators.remove(at: index)
                break
            }
        }
    }
        
    
    /// This is a way for the MainCoordinator to automatically detect when we are navigating back in our view controllers
    /// From there we can then determine whether we need to end a child coordinator.
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        /// Get the fromViewController
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        /// Check if navigationController, viewControllers contains the fromViewController
        /// If it does this means we are pushing a new View Controller on top of the fromViewController so return because we don' need to do anything
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        /// At this point we know we are popping a viewController
        /// Therefore identify the viewController and finish the child coordinator.
        if let accountViewController = fromViewController as? AccountViewController {
            childDidFinish(accountViewController.accountCoordinator)
        }
    }
    
    
    /// Example method to get user data
    private func getCurrentUser() -> User {
        /// This could come from:
        /// - A service/repository
        /// - Network call
        /// - Dependency injection
        return User(name: "John Doe", email: "john@example.com", age: 64)
    }
}
