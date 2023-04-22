//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Виктор on 08.04.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    // массив вопросов
/*    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Dark Knight",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Kill Bill",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Avengers",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Deadpool",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "The Green Knight",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Old",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Tesla",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Vivarium",
            correctAnswer: false
        ),
    ]*/
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies() { result in
            switch result {
            case .success(let movies):
                self.movies = movies.items
                self.delegate?.didLoadDataFromServer()
            case .failure(let error):
                self.delegate?.didFailToLoadData(with: error)
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let compareRating = Float((1...10).randomElement()!)
            let compareStrings = ["больше", "меньше"]
            var compareString = ""
            if compareRating == 1 {
                compareString = compareStrings[0]
            } else if compareRating == 10 {
                compareString = compareStrings[1]
            } else {
                compareString = compareStrings.randomElement()!
            }
            
            let text = "Рейтинг этого фильма \(compareString) чем \(compareRating)?"
            let correctAnswer = compareRating > rating
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
