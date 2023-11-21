//
//  DetailViewModel.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import Foundation

protocol DetailViewModelType {
    var caruselItems: [Book] { get }
    var likedBooks: [Book] { get }
    var onReload: (EmptyClosureType) { get set }
    var selectedModel: SelectedModel { get }
    
    func route(to route: DetailCoordinator.Route)
}

class DetailViewModel: DetailViewModelType {
    
    private let coordinator: DetailCoordinator
    private var booksDetailService: BooksDetailServiceType
    var caruselItems: [Book] = []
    var likedBooks: [Book] = []
    var onReload: (EmptyClosureType) = {  }
    var selectedModel: SelectedModel
    
    init(_ coordinator: DetailCoordinator, selectedModel: SelectedModel) {
        self.coordinator = coordinator
        self.booksDetailService = ServiceHolder.shared.get(by: BooksDetailService.self)
        self.selectedModel = selectedModel
        self.fetchCaruselData()
    }
    
    private func fetchCaruselData() {
        booksDetailService.fetchBooksDetail { [weak self] caruselItems in
            self?.caruselItems = caruselItems.books ?? []
            self?.createLikeSection(with: caruselItems)
        }
    }
    
    private func createLikeSection(with caruselItems: BooksDetailModel) {
        let likedBooks: [Book] = caruselItems.books?.filter { [weak self] book in
            if let bookID = book.id, let youWillLikeSection = self?.selectedModel.youWillLikeSection {
                return youWillLikeSection.contains(bookID)
            }
            return false
        } ?? []
        
        self.likedBooks = likedBooks
        self.onReload()
    }
   
    deinit {
        printDeinit(self)
    }
}

// MARK: - Navigation -

extension DetailViewModel {
    
    func route(to route: DetailCoordinator.Route) {
        coordinator.route(to: route)
    }
}
