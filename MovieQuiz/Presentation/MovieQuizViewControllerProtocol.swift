//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Виктор on 05.05.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func setInteractionEnabled(_ val: Bool)
    func show(quiz step: QuizStepViewModel)
    func showNetworkError(message: String)
    func showResult(message: String)
    func highlightImageBorder(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
