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
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
