//
//  BaseError.swift
//  ErrorHandlingTest
//
//  Created by YuriyFpc on 11/30/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

public protocol BaseErrorCode: RawRepresentable where RawValue == Int {}
extension BaseErrorCode  {
    var errorCase: String { return String(describing: self) }
}

struct BaseErrorInfoKeys {
    static let underlyingError: String = NSUnderlyingErrorKey
    static let errorMessage: String = "NSLocalizedDescription"//NSLocalizedFailureReasonErrorKey
    static let errorUrl: String = "NSErrorFailingURLStringKey"
    static let domainShortname: String = "domainShortname"
    static let statusCode: String = "statusCode" // external api error keys
    static let errorCase: String = "errorCase"
}

open class BaseError<ErrorCode: BaseErrorCode>: NSError {
    
    public required init(code: ErrorCode, underlying: Error? = nil, systemMsg: String? = nil, statusCode: String? = nil) {
        super.init(domain: "", code: code.rawValue, userInfo: nil)
        let userInfo = [BaseErrorInfoKeys.underlyingError: underlying as Any, BaseErrorInfoKeys.errorMessage: systemMsg as Any, BaseErrorInfoKeys.domainShortname: domainShortname(), BaseErrorInfoKeys.statusCode: statusCode ?? "", BaseErrorInfoKeys.errorCase: code.errorCase] as [String : Any]
        super.setValue(domain, forKeyPath: #keyPath(NSError.domain))
        super.setValue(userInfo, forKeyPath: #keyPath(NSError.userInfo))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var domain: String {
        return String(describing: type(of: self))
    }
    public var errorCode: ErrorCode {
        return ErrorCode(rawValue: code)!
    }
    public var errorCodeName: String {
        return String(describing: errorCode)
    }
    
    func domainShortname() -> String {
        return "BA"
    }
}
