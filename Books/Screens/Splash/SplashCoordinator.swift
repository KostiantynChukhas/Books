//
//  SplashCoordinator.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit

protocol SplashCoordinatorTransitions: AnyObject {
    func splashIsShown()
}

class SplashCoordinator {
    enum Route {
        case `self`
        case main
    }
    
    weak var transitions: SplashCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: SplashViewController? = Storyboard.splash.instantiate()
    
    private var viewModel: SplashViewModelType? {
        return controller?.viewModel
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = SplashViewModel(self)
    }
    
    deinit {
        printDeinit(self)
    }
}

// MARK: - Navigation -

extension SplashCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .main: splashIsShown()
    
        }
    }
    
    private func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func splashIsShown() {
        navigationController?.popViewController(animated: true)
        transitions?.splashIsShown()
    }
}
