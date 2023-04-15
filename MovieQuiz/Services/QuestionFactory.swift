//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Виктор on 08.04.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    
    // массив вопросов
    private let questions: [QuizQuestion] = [
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
    ]
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
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
