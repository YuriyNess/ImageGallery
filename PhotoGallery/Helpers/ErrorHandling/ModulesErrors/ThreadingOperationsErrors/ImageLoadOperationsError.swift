//
//  ImageLoadOperationsError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageLoadOperationsErrorCode: Int, BaseErrorCode {
    case startImageLoadOperation
}

class ImageLoadOperationsError: BaseError<ImageLoadOperationsErrorCode> {
    override func domainShortname() -> String {
        return "ILO"
    }
}
