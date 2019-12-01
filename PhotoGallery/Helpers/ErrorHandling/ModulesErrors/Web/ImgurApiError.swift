//
//  ImgurApiError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImgurApiErrorCode: Int, BaseErrorCode {
    case upload
    case parsing
}

class ImgurApiError: BaseError<ImgurApiErrorCode> {
    override func domainShortname() -> String {
        return "IA"
    }
}
