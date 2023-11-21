import Foundation
import FirebaseRemoteConfig

protocol BooksServiceType: Service {
    func fetchRemoteConfig(completion: @escaping SimpleClosure<[BooksSection]>)
}

struct BooksSection {
    let title: String
    let items: [Book]
    let topBannerSlides: [TopBannerSlide]?
    let youWillLikeSection: [Int]
}


class BooksService: BooksServiceType {
    
    func fetchRemoteConfig(completion: @escaping SimpleClosure<[BooksSection]>) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        // Enable developer mode to make fetch requests more frequently (for testing purposes)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                print("Config fetched successfully!")
                remoteConfig.activate { (_, _) in
                    self.applyRemoteConfig(completion: completion)
                }
            } else {
                print("Config fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
   private func applyRemoteConfig(completion: @escaping SimpleClosure<[BooksSection]>) {
        let yourJsonData = RemoteConfig.remoteConfig()["json_data"].stringValue ?? "{}"
        
        if let jsonData = yourJsonData.data(using: .utf8) {
            do {
                let bookModel = try JSONDecoder().decode(BooksModel.self, from: jsonData)
                completion(createSectionsFromBooksModel(bookModel))
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
    
    private func createSectionsFromBooksModel(_ booksModel: BooksModel) -> [BooksSection] {
        guard let books = booksModel.books else {
            return []
        }

        var sections: [BooksSection] = []

        // Create a dictionary to group books by genre
        var genreDictionary: [String: [Book]] = [:]

        for book in books {
            if let genre = book.genre {
                if genreDictionary[genre] == nil {
                    genreDictionary[genre] = [book]
                } else {
                    genreDictionary[genre]?.append(book)
                }
            }
        }

        // Create a BooksSection for each genre
        for (genre, genreBooks) in genreDictionary {
            let section = BooksSection(
                title: genre,
                items: genreBooks,
                topBannerSlides: booksModel.topBannerSlides,
                youWillLikeSection: booksModel.youWillLikeSection ?? []
            )
            sections.append(section)
        }

        return sections
    }
    
    deinit {
        printDeinit(self)
    }
}
