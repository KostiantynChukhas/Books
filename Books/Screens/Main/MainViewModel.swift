//
//  MainViewModel.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import Foundation

struct SelectedModel {
    let bookId: Int
    let topBannerSlides: [TopBannerSlide]?
    let youWillLikeSection: [Int]
}

protocol MainViewModelType {
    var section: [BooksSection] { get }
    var onReload: (EmptyClosureType) { get set }
    
    func makeSelected(with bookId: Int)
    func route(to route: MainCoordinator.Route)
}

class MainViewModel: MainViewModelType {
    private var coordinator: MainCoordinator
    private var booksService: BooksServiceType
    
    var section: [BooksSection] = []
    var onReload: (EmptyClosureType) = {  }
    
    init(_ coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.booksService = ServiceHolder.shared.get(by: BooksService.self)
        getBooks()
    }
    
    private func getBooks() {
        booksService.fetchRemoteConfig { [weak self] section in
            self?.section = section
            self?.onReload()
        }
    }
    
    func route(to route: MainCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    func makeSelected(with bookId: Int) {
        let selectedModel = SelectedModel(bookId: bookId, topBannerSlides: section.first?.topBannerSlides, youWillLikeSection: section.first?.youWillLikeSection ?? [])
        route(to: .detail(model: selectedModel))
    }
    
    deinit {
        printDeinit(self)
    }
}
