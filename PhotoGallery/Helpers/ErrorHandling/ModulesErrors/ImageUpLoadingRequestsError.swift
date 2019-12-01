//
//  ImageUpLoadingRequestsError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageUpLoadingRequestsErrorCode: Int, BaseErrorCode {
    case performUpLoadImage
}

class ImageUpLoadingRequestsError: BaseError<ImageUpLoadingRequestsErrorCode> {
    override func domainShortname() -> String {
        return "IUR"
    }
}
