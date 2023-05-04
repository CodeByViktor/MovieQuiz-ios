//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Виктор on 21.04.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // URL https://imdb-api.com/en/API/Top250Movies/k_j8f1robq
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_j8f1robq") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                let decodedMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                guard let decodedMovies = decodedMovies else { return }
                handler(.success(decodedMovies))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
