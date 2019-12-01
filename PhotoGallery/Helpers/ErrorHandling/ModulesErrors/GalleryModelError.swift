//
//  GalleryModelError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum GalleryModelErrorCode: Int, BaseErrorCode {
    case upload = 0
}

class GalleryModelError: BaseError<GalleryModelErrorCode> {
    override func domainShortname() -> String {
        return "GM"
    }
}
