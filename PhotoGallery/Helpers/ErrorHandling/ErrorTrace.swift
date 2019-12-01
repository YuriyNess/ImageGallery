//
//  UserError.swift
//  ErrorHandlingTest
//
//  Created by YuriyFpc on 11/30/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

class ErrorTrace {
    var error: NSError
    init(error: NSError) {
        self.error = error
    }
    
    func showUser(presenter: UIViewController) {
        let message = "\(makeMessageChain())\n\(makeUrlChain())\n\(makeShortCodeChain())"
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
    
    func makeFuncTraceChain() -> String {
        return funcTraceChain(error: error)
    }
    
    func makeShortCodeChain() -> String {
        return shortCodeChain(error: error)
    }
    
    func makeUrlChain() -> String {
        return urlChain(error: error)
    }
    
    func makeUserMessageChain() -> String {
        return userMessageChain(error: error)
    }
    
    private func userMessageChain(error: NSError) -> String {
        let message = error.userInfo[BaseErrorInfoKeys.userMessage] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return userMessageChain(error: parentError) + " " + message
        } else {
            return message
        }
    }

    private func urlChain(error: NSError) -> String {
        let url = error.userInfo[BaseErrorInfoKeys.errorUrl] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            let chain = urlChain(error: parentError)
            return url == "" ? (chain) : (chain + "\n" + url)
        } else {
            return url
        }
    }
    
    private func shortCodeChain(error: NSError) -> String {
        let shortName = error.userInfo[BaseErrorInfoKeys.domainShortname] as? String ?? ""
        let errorCode = "\(error.code)"
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return shortCodeChain(error: parentError) + "/" + shortName + " " + errorCode
        } else {
            return shortName + " " + errorCode
        }
    }
    
    private func funcTraceChain(error: NSError) -> String {
        let shortName = error.userInfo[BaseErrorInfoKeys.domainShortname] as? String ?? ""
        let errorCase = error.userInfo[BaseErrorInfoKeys.errorCase] as? String ?? ""
        if let parentError = error.userInfo[BaseErrorInfoKeys.underlyingError] as? NSError {
            return funcTraceChain(error: parentError) + "/" + shortName + "+" + errorCase
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
