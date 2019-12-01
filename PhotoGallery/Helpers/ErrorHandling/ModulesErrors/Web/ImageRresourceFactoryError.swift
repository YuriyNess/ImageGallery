//
//  ImageRresourceFactoryError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageRresourceFactoryErrorCode: Int, BaseErrorCode {
    case parsing
}

class ImageRresourceFactoryError: BaseError<ImageRresourceFactoryErrorCode> {
    override func domainShortname() -> String {
        return "IRF"
    }
}
