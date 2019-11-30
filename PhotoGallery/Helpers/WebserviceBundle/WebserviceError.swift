//
//  WebserviceError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/30/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

enum WebserviceErrorCode: Int, BaseErrorCode {
    case post
    case get
}

class WebserviceError: BaseError<WebserviceErrorCode> {
    override func domainShortname() -> String {
        return "WEB"
    }
}
