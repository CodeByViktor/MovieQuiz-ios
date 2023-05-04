import UIKit
import Dispatch

final class MovieQuizViewController: UIViewController {
    // MARK: Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter!

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.borderColor = UIColor.clear.cgColor
        textLabel.text = step.question
        
        view.isUserInteractionEnabled = true // включаем интерактивность
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
            
        }
        alertPresenter?.show(alertModel)
    }
    
    func showResult(message: String) {
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message,
                                    buttonText: "Cыграть еще раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // Show & Hide loadingIndicator
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
