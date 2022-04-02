//
//  MovieNetworkStore.swift
//  
//
//  Created by Ravi Tripathi on 24/10/21.
//

import Foundation
import OSLog

enum Endpoints {
    case search(String)
    case details(String)
    
    func getQueryItem() -> URLQueryItem {
        switch self {
        case .search(let searchTerm):
            return URLQueryItem(name: "s", value: searchTerm)
        case .details(let movieId):
            return URLQueryItem(name: "i", value: movieId)
        }
    }
}

struct MovieNetworkStore {
    let baseUrl = URL(string: Constants.baseUrlString)!
    let apikeyQuery = URLQueryItem(name: "apikey", value: Constants.apiKey)
    let pageNumber = 1

    func search(movie: String) async throws -> MovieList {
        let searchEndpoint = Endpoints.search(movie)
        let queryItems = [ searchEndpoint.getQueryItem(),
                           URLQueryItem(name: "apikey", value: Constants.apiKey),
                           URLQueryItem(name: "page", value: "1")
                         ]
        guard var urlComponents = URLComponents(string: Constants.baseUrlString) else { throw "Invalid URL" }
        urlComponents.queryItems = queryItems
        guard let resolvedUrl = urlComponents.url else { throw "Invalid URL" }
        let (data, response) = try await URLSession.shared.data(from: resolvedUrl)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw "Not valid request" }
        return try JSONDecoder().decode(MovieList.self, from: data)
    }
    
    func getMovieDetails(movieId: String) async throws -> MovieDetails {
        let detailEndpoint = Endpoints.details(movieId)
        let queryItems = [ detailEndpoint.getQueryItem(),
                           URLQueryItem(name: "apikey", value: Constants.apiKey)
                         ]
        guard var urlComponents = URLComponents(string: Constants.baseUrlString) else { throw "Incorrect base url" }
        urlComponents.queryItems = queryItems
        guard let resolvedUrl = urlComponents.url else { throw "Query Items did not produce a valid URL" }
        
        let (data, response) = try await URLSession.shared.data(from: resolvedUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw "Not valid request" }
        return try JSONDecoder().decode(MovieDetails.self, from: data)
    }
}


extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
