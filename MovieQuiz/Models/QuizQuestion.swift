//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Виктор on 08.04.2023.
//

import Foundation

struct QuizQuestion {
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: Data
  // строка с вопросом о рейтинге фильма
  let text: String = "Рейтинг этого фильма больше чем 6?"
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}
