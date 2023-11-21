//
//  AuthCoordinator.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

protocol AuthCoordinatorTransitions: class {
    func didLoggedIn()
}

class AuthCoordinator {
    private var window: UIWindow
    
    weak var transitions: AuthCoordinatorTransitions?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    private var coordinator: MainCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = root
        
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        coordinator = MainCoordinator(navigationController: root)
        coordinator?.transitions = self
        coordinator?.route(to: .`self`)
    }
}

// MARK: - MainCoordinatorTransitions -

extension AuthCoordinator: MainCoordinatorTransitions {
    func didLoggedIn() {
        transitions?.didLoggedIn()
    }
}
