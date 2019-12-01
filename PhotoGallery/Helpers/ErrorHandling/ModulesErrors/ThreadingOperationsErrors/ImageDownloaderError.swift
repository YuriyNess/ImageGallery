//
//  ImageDownloaderError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

enum ImageDownloaderErrorCode: Int, BaseErrorCode {
    case main
}

class ImageDownloaderError: BaseError<ImageDownloaderErrorCode> {
    override func domainShortname() -> String {
        return "ID"
    }
}
