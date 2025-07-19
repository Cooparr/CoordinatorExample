//
//  LocationsViewController.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

class LocationsViewController: UIViewController {
    
    weak var locationCoordinator: LocationsCoordinator?

    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Locations Coordinator"
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
