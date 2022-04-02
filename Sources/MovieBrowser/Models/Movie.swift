//
//  Movie.swift
//  MovieBrowser
//
//  Created by Ravi Tripathi on 14/09/21.
//

import Foundation

// MARK: - MovieList
struct MovieList: Codable {
    let search: [Movie]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Movie: Codable, Identifiable {
    let title, year, imdbID: String
    var id = UUID()
    let type: TypeEnum
    let poster: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}
