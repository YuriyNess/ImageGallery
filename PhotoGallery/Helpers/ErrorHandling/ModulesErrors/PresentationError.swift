//
//  PresentationError.swift
//  ErrorHandlingTest
//
//  Created by YuriyFpc on 11/30/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum PresentationErrorCode: Int, BaseErrorCode {
    case undefined = 0
    case didSelectItemAt
}

class PresentationError: BaseError<PresentationErrorCode> {
    override func domainShortname() -> String {
        return "PR"
    }
}



