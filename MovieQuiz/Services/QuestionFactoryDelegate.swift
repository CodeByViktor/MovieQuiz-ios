//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Виктор on 09.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
