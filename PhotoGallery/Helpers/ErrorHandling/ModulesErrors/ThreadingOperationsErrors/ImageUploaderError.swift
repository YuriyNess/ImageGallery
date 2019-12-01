//
//  ImageUploaderError.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/1/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

enum ImageUploaderErrorCode: Int, BaseErrorCode {
    case main
}

class ImageUploaderError: BaseError<ImageUploaderErrorCode> {
    override func domainShortname() -> String {
        return "IU"
    }
}


