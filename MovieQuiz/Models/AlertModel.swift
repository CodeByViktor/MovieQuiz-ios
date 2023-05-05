//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Виктор on 09.04.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
