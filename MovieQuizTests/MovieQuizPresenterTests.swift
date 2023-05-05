//
//  PresenterTests.swift
//  MovieQuizTests
//
//  Created by Виктор on 05.05.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setInteractionEnabled(_ val: Bool) {}
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func showNetworkError(message: String) {}
    func showResult(message: String) {}
    func highlightImageBorder(isCorrect: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testConvertModel() throws {
        let movieQuizCtrlMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: movieQuizCtrlMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
