//
//  ResourceError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//


enum ResourceErrorCode: Int, BaseErrorCode {
    case parse = 0
}

class ResourceError: BaseError<ResourceErrorCode> {
    override func domainShortname() -> String {
        return "R"
    }
}
