//
//  ViewController+Alert.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 22.06.2024.
//

import UIKit

extension ViewController {
    func showAlert(title: String, message: String, buttonTitle: String? = "OK", showCancel: Bool = false, buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        print(title + "\n" + message)
        
        var actions = [UIAlertAction]()
        if let buttonTitle = buttonTitle {
            actions.append(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
        }
        if showCancel {
            actions.append(UIAlertAction(title: "Cancel", style: .cancel))
        }
        self.showAlert(title: title, message: message, actions: actions)
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let showAlertBlock = {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { alertController.addAction($0) }
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        DispatchQueue.main.async {
            if self.presentedViewController != nil {
                self.dismiss(animated: true) {
                    showAlertBlock()
                }
            } else {
                showAlertBlock()
            }
        }
    }
}
