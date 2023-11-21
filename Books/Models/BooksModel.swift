
import Foundation

// MARK: - BooksModel
struct BooksModel: Codable {
    let books: [Book]?
    let topBannerSlides: [TopBannerSlide]?
    let youWillLikeSection: [Int]?

    enum CodingKeys: String, CodingKey {
        case books
        case topBannerSlides = "top_banner_slides"
        case youWillLikeSection = "you_will_like_section"
    }
}

// MARK: - Book
struct Book: Codable {
    let id: Int?
    let name, author, summary, genre: String?
    let coverURL: String?
    let views, likes, quotes: String?

    enum CodingKeys: String, CodingKey {
        case id, name, author, summary, genre
        case coverURL = "cover_url"
        case views, likes, quotes
    }
}

// MARK: - TopBannerSlide
struct TopBannerSlide: Codable {
    let id, bookID: Int?
    let cover: String?

    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case cover
    }
}
