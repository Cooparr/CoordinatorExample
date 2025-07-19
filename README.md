# iOS Coordinator Pattern Example

A comprehensive iOS project demonstrating the **Coordinator Pattern** for navigation management in UIKit apps, including tab bar integration and child coordinators.

## What is the Coordinator Pattern?

The Coordinator Pattern separates navigation logic from view controllers, making your code more:
- **Testable** - Navigation logic can be unit tested independently
- **Reusable** - View controllers don't know how they're presented
- **Maintainable** - All navigation logic is centralized in coordinators
- **Flexible** - Easy to change navigation flows without touching view controllers

## Project Structure

```
CoordinatorExample/
├── Coordinators/
│   ├── MainCoordinator.swift          # Main tab navigation coordinator
│   ├── LocationsCoordinator.swift     # Locations tab coordinator
│   └── AccountCoordinator.swift       # Child coordinator for account flow
├── ViewControllers/
│   ├── TabBarViewController.swift     # Tab bar setup and coordinator management
│   ├── MainViewController.swift       # Main tab content
│   ├── LocationsViewController.swift  # Locations tab content
│   ├── AccountViewController.swift    # Account screen (managed by child coordinator)
│   ├── DetailViewController.swift     # Simple detail screen
│   └── BottomSheetViewController.swift # Example modal presentation
├── Models/
│   └── User.swift                     # Example data model
├── AppDelegate.swift
└── SceneDelegate.swift               # App entry point
```

## Key Features Demonstrated

### ✅ Tab Bar with Coordinators
- Each tab has its own coordinator and navigation stack
- Independent navigation flows per tab
- Centralized tab bar configuration

### ✅ Child Coordinators
- Complex flows managed by child coordinators
- Automatic memory management and cleanup
- Parent-child coordinator relationships

### ✅ Data Passing
- Type-safe data injection through coordinators
- Dynamic titles based on data
- Proper dependency management

### ✅ Multiple Navigation Types
- Push navigation within tabs
- Modal presentation (bottom sheets)
- Child coordinator navigation

### ✅ Navigation Bar Customization
- Per-coordinator navigation bar styling
- Large titles support
- Custom appearance configurations

## Architecture Overview

```
TabBarViewController
├── MainCoordinator (Tab 1)
│   ├── MainViewController
│   ├── DetailViewController
│   ├── BottomSheetViewController (modal)
│   └── AccountCoordinator (child)
│       └── AccountViewController
└── LocationsCoordinator (Tab 2)
    └── LocationsViewController
```

## How It Works

### 1. App Launch & Tab Setup
```swift
// SceneDelegate creates the tab bar controller
window?.rootViewController = TabBarViewController()

// TabBarViewController sets up coordinators for each tab
class TabBarViewController: UITabBarController {
    private var mainCoordinator: MainCoordinator?
    private var locationsCoordinator: LocationsCoordinator?
    
    override func viewDidLoad() {
        let mainNavController = UINavigationController()
        let locationNavController = UINavigationController()
        
        mainCoordinator = MainCoordinator(navigationController: mainNavController)
        locationsCoordinator = LocationsCoordinator(navigationController: locationNavController)
        
        // Configure tab items and start coordinators
    }
}
```

### 2. Tab-Specific Navigation
```swift
// Each tab has its own coordinator managing its navigation stack
class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    func start() {
        let vc = MainViewController()
        vc.mainCoordinator = self
        vc.title = "Main VC"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetailViewController() {
        let vc = DetailViewController()
        vc.mainCoordinator = self
        vc.title = "Some Detail VC"
        navigationController.pushViewController(vc, animated: true)
    }
}
```

### 3. Child Coordinator with Data
```swift
// Complex flows use child coordinators
func showAccount() {
    let currentUser = getCurrentUser()
    let child = AccountCoordinator(navigationController: navigationController)
    child.parentCoordinator = self
    childCoordinators.append(child)
    child.start(user: currentUser)
}
```

### 4. Automatic Memory Management
```swift
// Coordinators automatically clean up child coordinators when users navigate back
func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    // Detect back navigation and cleanup child coordinators
    if let accountViewController = fromViewController as? AccountViewController {
        childDidFinish(accountViewController.accountCoordinator)
    }
}
```

## Key Classes

### `Coordinator Protocol`
```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}
```

### `TabBarViewController`
- Sets up tab bar with navigation controllers
- Creates and manages top-level coordinators
- Configures tab bar items and appearance

### `MainCoordinator`
- Manages navigation for the main tab
- Demonstrates push navigation, modal presentation, and child coordinators
- Custom navigation bar styling (white text on transparent background)

### `LocationsCoordinator`
- Manages navigation for the locations tab
- Independent navigation stack from main tab
- Different navigation bar styling (black text)

### `AccountCoordinator`
- Child coordinator demonstrating data passing
- Takes a `User` object via dependency injection
- Managed by parent coordinator lifecycle

## Navigation Examples

### Push Navigation
```swift
func showDetailViewController() {
    let vc = DetailViewController()
    vc.mainCoordinator = self
    vc.title = "Some Detail VC"
    navigationController.pushViewController(vc, animated: true)
}
```

### Modal Presentation (Bottom Sheet)
```swift
func presentSomeBottomSheet() {
    let bottomSheetViewController = BottomSheetViewController()
    bottomSheetViewController.mainCoordinator = self
    bottomSheetViewController.modalPresentationStyle = .pageSheet
    
    if let sheet = bottomSheetViewController.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.preferredCornerRadius = 16
        sheet.prefersGrabberVisible = true
    }
    
    navigationController.present(bottomSheetViewController, animated: true)
}
```

### Child Coordinator with Data Injection
```swift
func showAccount() {
    let currentUser = getCurrentUser()
    let child = AccountCoordinator(navigationController: navigationController)
    child.parentCoordinator = self
    childCoordinators.append(child)
    child.start(user: currentUser)
}

// In AccountCoordinator
func start(user: User) {
    let vc = AccountViewController(user: user)
    vc.accountCoordinator = self
    vc.title = user.name
    navigationController.pushViewController(vc, animated: true)
}
```

## Memory Management

The project demonstrates proper memory management through:

1. **Strong coordinator references** in `TabBarViewController`
2. **Weak coordinator references** in view controllers
3. **Automatic child coordinator cleanup** when navigating back
4. **Parent-child relationships** preventing retain cycles

```swift
// TabBarViewController keeps coordinators alive
private var mainCoordinator: MainCoordinator?
private var locationsCoordinator: LocationsCoordinator?

// View controllers hold weak references
weak var mainCoordinator: MainCoordinator?
weak var accountCoordinator: AccountCoordinator?
```

## Data Models

### User Model
```swift
struct User: Codable, Identifiable {
    private(set) var id = UUID()
    let name: String
    let email: String
    let age: Int
}
```

Used to demonstrate type-safe data passing between coordinators and dependency injection into view controllers.

## Best Practices Demonstrated

- ✅ **Tab-specific navigation stacks** - Each tab maintains independent navigation
- ✅ **Coordinator ownership** - Tab bar controller owns top-level coordinators
- ✅ **Data flows through coordinators** - No direct view controller communication
- ✅ **Centralized navigation configuration** - All navigation logic in coordinators
- ✅ **Automatic memory management** - Proper cleanup prevents memory leaks
- ✅ **Consistent patterns** - Same approach for push, present, and child coordinators

## Running the Project

1. Open `CoordinatorExample.xcodeproj` in Xcode
2. Select your target device/simulator
3. Press `Cmd + R` to run

The app will launch with a tab bar containing:
- **Main Tab**: Demonstrates push navigation, modals, and child coordinators
- **Locations Tab**: Independent navigation stack with different styling

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

## Navigation Flows

### Main Tab Flow
```
MainViewController
├── DetailViewController (push)
├── BottomSheetViewController (modal)
└── AccountCoordinator
    └── AccountViewController (with User data)
```

### Locations Tab Flow
```
LocationsViewController
└── (Additional location-specific navigation can be added)
```

## Benefits Over Traditional Navigation

| Traditional Approach | Coordinator Pattern |
|---------------------|-------------------|
| Navigation scattered across VCs | Navigation centralized in coordinators |
| Tight coupling between screens | Loose coupling through coordinator interface |
| Hard to test navigation flows | Easy to unit test coordinators |
| Difficult to change app flow | Easy to modify flows in coordinators |
| Memory management issues | Automatic coordinator cleanup |
| Mixed responsibilities | Clear separation of concerns |

## Extension Ideas

This project can be extended with:
- More complex tab flows
- Deep linking support
- Navigation state restoration
- Coordinator-based authentication flows
- Custom transition animations
- Universal link handling

---

*This project serves as a comprehensive foundation for implementing the Coordinator Pattern in production iOS apps with tab bar navigation.*
