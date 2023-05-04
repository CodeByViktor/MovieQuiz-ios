//
//  MoviQuizPresenter.swift
//  MovieQuiz
//
//  Created by Виктор on 04.05.2023.
//

import UIKit

final class MovieQuizPresenter {
    weak var viewController: MovieQuizViewController?
    let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // MARK: - UserActions
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
}
