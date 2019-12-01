//
//  ImageUploadOperationsError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageUploadOperationsErrorCode: Int, BaseErrorCode {
    case startImageUpLoadOperation
}

class ImageUploadOperationsError: BaseError<ImageUploadOperationsErrorCode> {
    override func domainShortname() -> String {
        return "IUO"
    }
}
