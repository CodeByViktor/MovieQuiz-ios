//
//  MoviQuizPresenter.swift
//  MovieQuiz
//
//  Created by Виктор on 04.05.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewController?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.loadData()
        
        self.viewController?.showLoadingIndicator()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
            notificationGenerator.notificationOccurred(.success)
        } else {
            notificationGenerator.notificationOccurred(.error)
        }
        
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        viewController?.view.isUserInteractionEnabled = false // выключает интерактивность
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func makeResultsMessage() -> String {
        let message = """
        Ваш результат \(correctAnswers)/\(questionsAmount)"
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        return message
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let message = makeResultsMessage()
            
            viewController?.showResult(message: message)
            
        } else {
            switchToNextQuestion()
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Public QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - UserActions
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
}
