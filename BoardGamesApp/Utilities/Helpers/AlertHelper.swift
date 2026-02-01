//
//  AlertHelper.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import UIKit

final class AlertHelper {
    static func showError(
        _ message: String,
        title: String = "Error",
        on viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    static func showSuccess(
         _ message: String,
         title: String = "Success",
         on viewController: UIViewController,
         completion: (() -> Void)? = nil
     ) {
         let alert = UIAlertController(
             title: title,
             message: message,
             preferredStyle: .alert
         )
         
         alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
             completion?()
         })
         
         viewController.present(alert, animated: true)
     }
    
    static func showAlert(
        title: String,
        message: String,
        on viewController: UIViewController,
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alert.addAction($0) }
        }
        
        viewController.present(alert, animated: true)
    }
    
    static func showConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        on viewController: UIViewController,
        confirmHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler()
        })
        
        viewController.present(alert, animated: true)
    }
}
