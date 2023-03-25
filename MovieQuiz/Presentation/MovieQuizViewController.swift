import UIKit
import Dispatch

final class MovieQuizViewController: UIViewController {
    
    private struct QuizQuestion {
      // строка с названием фильма,
      // совпадает с названием картинки афиши фильма в Assets
      let image: String
      // строка с вопросом о рейтинге фильма
      let text: String = "Рейтинг этого фильма больше чем 6?"
      // булевое значение (true, false), правильный ответ на вопрос
      let correctAnswer: Bool
    }

    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
      // картинка с афишей фильма с типом UIImage
      let image: UIImage
      // вопрос о рейтинге квиза
      let question: String
      // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }

    private struct QuizResultsViewModel {
      // строка с заголовком алерта
      let title: String
      // строка с текстом о количестве набранных очков
      let text: String
      // текст для кнопки алерта
      let buttonText: String
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    
    let notificationGenerator = UINotificationFeedbackGenerator()
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[0]))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: true == questions[currentQuestionIndex].correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: false == questions[currentQuestionIndex].correctAnswer)
    }
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      return QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
      )
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.convert(model: self.questions[0])
            self.show(quiz: firstQuestion)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
            notificationGenerator.notificationOccurred(.success)
        } else {
            notificationGenerator.notificationOccurred(.error)
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        view.isUserInteractionEnabled = false // выключает интерактивность
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        view.isUserInteractionEnabled = true // включаем интерактивность
        
        if currentQuestionIndex == questions.count - 1 {
            let resultView = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат \(correctAnswers)/\(questions.count)",
                buttonText: "Cыграть еще раз"
            )
            show(quiz: resultView)
        } else {
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            let nextViewQuestion = convert(model: questions[currentQuestionIndex])
            show(quiz: nextViewQuestion)
        }
    }
}
