//
//  DetailCoordinator.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

protocol DetailCoordinatorTransitions: AnyObject {
}

class DetailCoordinator {
    
    enum Route {
        case `self`
        case back
    }
    
    weak var transitions: DetailCoordinatorTransitions?
    
    private weak var navigationController: UINavigationController?
    private weak var controller: DetailViewController? = Storyboard.booksDetail.instantiate()
    
    private var viewModel: DetailViewModelType? {
        return controller?.viewModel
    }
    
    init(navigationController: UINavigationController?, model: SelectedModel) {
        self.navigationController = navigationController
        controller?.viewModel = DetailViewModel(self, selectedModel: model)
    }

    
    deinit {
        print("DetailCoordinator - deinit")
    }
}

extension DetailCoordinator {
    
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        case .back: back()
        }
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
