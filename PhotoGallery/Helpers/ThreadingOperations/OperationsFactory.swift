//
//  OperationsFactory.swift
//  FilmsOverviewApp
//
//  Created by YuriyFpc on 9/7/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

final class OperationsFactory {
    func createImageLoadOperation(url: String, service: ImageLoadingRequests, resourceFactory: ImageRresourceFactory) -> ImageDownloader {
        return ImageDownloader(service: service, resourceFactory: resourceFactory, url: url)
    }
    
    func createImageUpLoadOperation(imageName: String, imageTitle: String, image: UIImage, service: ImageUpLoadingRequests, resourceFactory: ImageImgurUploadResourceFactory) -> ImageUploader {
        return ImageUploader(service: service, resourceFactory: resourceFactory, imageName: imageName, imageTitle: imageTitle, image: image)
    }
}

