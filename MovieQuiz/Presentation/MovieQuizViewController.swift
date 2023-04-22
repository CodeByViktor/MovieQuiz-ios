import UIKit
import Dispatch

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: Properties
    private let notificationGenerator = UINotificationFeedbackGenerator()
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
/*    func getMovie(from jsonString: String) -> Movie? {
        let data = jsonString.data(using: .utf8)
        guard let data = data else { return nil }
        
        var movie: Movie?
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let actorList = json?["actorList"] as! [Any]
            var actorListArray: [Actor] = []
            for actor in actorList {
                if let actor = actor as? [String: Any] {
                    actorListArray.append(Actor(id: actor["id"] as? String ?? "",
                                           image: actor["image"] as? String ?? "",
                                           name: actor["name"] as? String ?? "",
                                           asCharacter: actor["asCharacter"] as? String ?? ""))
                }
            }
            movie = Movie(id: json?["id"] as? String ?? "",
                          title: json?["title"] as? String ?? "",
                          year: json?["year"] as? Int ?? 0,
                          image: json?["image"] as? String ?? "",
                          releaseDate: json?["releaseDate"] as? String ?? "",
                          runtimeMins: json?["runtimeMins"] as? Int ?? 0,
                          directors: json?["directors"] as? String ?? "",
                          actorList: actorListArray)
        } catch {
            print("Faled to parse")
        }
        
        return movie
    }*/
    
    // MARK: - Private methods
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        
        view.isUserInteractionEnabled = true // включаем интерактивность
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            var message = "Ваш результат \(correctAnswers)/\(questionsAmount)"
            if let statisticService = statisticService {
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                message += """
                \nКоличество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                """
            }
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: message,
                                        buttonText: "Cыграть еще раз") { [weak self] _ in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.show(alertModel)
            
        } else {
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }
            self.questionFactory?.loadData()
            
        }
        alertPresenter?.show(alertModel)
    }
    
    // Show & Hide loadingIndicator
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // MARK: - Public QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
}
