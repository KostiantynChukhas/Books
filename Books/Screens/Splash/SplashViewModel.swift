//
//  SplashViewModel.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import Foundation

protocol SplashViewModelType {
    func route(to route: SplashCoordinator.Route)
}

class SplashViewModel: SplashViewModelType {
    
    fileprivate let coordinator: SplashCoordinator
    
    init(_ coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    func route(to route: SplashCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    deinit {
        print("SplashViewModel - deinit")
    }
}
