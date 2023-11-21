//
//  MainCoordinator.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

protocol MainCoordinatorTransitions: AnyObject {
    func didLoggedIn()
}

class MainCoordinator {
    enum Route {
        case `self`
        case detail(model: SelectedModel)
    }
    
    weak var transitions: MainCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: MainViewController? = Storyboard.main.instantiate()
    
    private var viewModel: MainViewModelType? {
        return controller?.viewModel
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = MainViewModel(self)
    }
    
    deinit {
        printDeinit(self)
    }
}

// MARK: - Navigation -

extension MainCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .detail(let model): detail(model: model)
        }
    }
    
    private func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func detail(model: SelectedModel) {
        let coordinator = DetailCoordinator(navigationController: navigationController, model: model)
        coordinator.transitions = self
        coordinator.route(to: .`self`)
    }
}

extension MainCoordinator: DetailCoordinatorTransitions {
    func didLoggedIn() {
        transitions?.didLoggedIn()
    }
    
    
}


