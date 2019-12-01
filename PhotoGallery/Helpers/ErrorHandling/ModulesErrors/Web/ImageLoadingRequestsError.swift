//
//  ImageLoadingRequestsError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageLoadingRequestsErrorCode: Int, BaseErrorCode {
    case performLoadImage
}

class ImageLoadingRequestsError: BaseError<ImageUpLoadingRequestsErrorCode> {
    override func domainShortname() -> String {
        return "ILR"
    }
}
