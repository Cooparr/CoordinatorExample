//
//  MainViewController.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    weak var mainCoordinator: MainCoordinator?
    
    /// Just an example of how MainCoordinator would present another VC.
    @objc private func showBottomSheet() {
        mainCoordinator?.presentSomeBottomSheet()
    }
    
    /// Imagine we are navigating to so details screen but it doesn't navigate anywhere else itself.
    /// Just an example of how MainCoordinator can push to another VC
    @objc private func navigateToDetail() {
        mainCoordinator?.showDetailViewController()
    }
    
    
    /// Imagine we want to navigate to some account page
    /// Just an example of how MainCoordinator can push to a child coordinator.
    @objc private func navigateToAccount() {
        mainCoordinator?.showAccount()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: - View Related Code
    /// Would usually put in this in a custom view class but doesn't really matter for the purpose of this project.
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 24
        return stackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Coordinator Pattern!"
        label.textColor = .white
        return label
    }()
    
    
    lazy var bottomSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Bottom Sheet", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        button.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Detail VC", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        button.addTarget(self, action: #selector(navigateToDetail), for: .touchUpInside)
        
        return button
    }()
    
    lazy var accountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Account Coordinator", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        button.addTarget(self, action: #selector(navigateToAccount), for: .touchUpInside)
        
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(bottomSheetButton)
        stackView.addArrangedSubview(detailButton)
        stackView.addArrangedSubview(accountButton)
        stackView.setCustomSpacing(48, after: label)
    }
}
