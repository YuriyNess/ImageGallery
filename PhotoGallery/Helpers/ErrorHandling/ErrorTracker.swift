//
//  UserError.swift
//  ErrorHandlingTest
//
//  Created by YuriyFpc on 11/30/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

class ErrorTracker {
    var error: PresentationError
    init(error: PresentationError) {
        self.error = error
    }
    
    func showUser(presenter: UIViewController) {
        let message = "\(makeMessageChain())\n\(makeDescriptionChain())"  
        presenter.showErrorAlert(title: "Error", message: message)
    }
    
    func makeMessageChain() -> String {
        return messageChain(error: error)
    }
    
    func makeDomainChain() -> String {
        return domainChain(error: error)
    }
    
    func makeShortnameChain() -> String {
        return shortnameChain(error: error)
    }
    
    func makeDescriptionChain() -> String {
        return descriptionChain(error: error)
    }
    
    private func descriptionChain(error: NSError) -> String {
        let shortName = error.userInfo[BaseErrorInfoKeys.domainShortname] as? String ?? ""
        let errorCase = error.userInfo[BaseErrorInfoKeys.errorCase] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return descriptionChain(error: parentError) + "/" + shortName + "+" + errorCase
        } else {
            return shortName + "+" + errorCase
        }
    }
    
    private func shortnameChain(error: NSError) -> String {
        let shortName = error.userInfo[BaseErrorInfoKeys.domainShortname] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return shortnameChain(error: parentError) + "/" + shortName
        } else {
            return shortName
        }
    }
    
    private func domainChain(error: NSError) -> String {
        let domain = error.domain
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return domainChain(error: parentError) + "/" + domain
        } else {
            return domain
        }
    }
    
    private func messageChain(error: NSError) -> String {
        let message = error.userInfo[BaseErrorInfoKeys.errorMessage] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return messageChain(error: parentError) + " " + message
        } else {
            return message
        }
    }
}


extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
