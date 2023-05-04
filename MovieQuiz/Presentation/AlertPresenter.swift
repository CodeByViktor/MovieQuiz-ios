//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Виктор on 09.04.2023.
//

import UIKit

class AlertPresenter {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func show(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "EndAlert"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
