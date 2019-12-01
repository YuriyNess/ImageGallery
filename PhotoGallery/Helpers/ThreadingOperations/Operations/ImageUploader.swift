//
//  ImageUploader.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation
import UIKit

final class ImageUploader: Operation {
    var data: Any?
    var loadingCompleteHandler: ((Any) ->Void)?
    var loadingErrorHandler: ((Error?) -> Void)?
    
    private let service: ImageUpLoadingRequests
    private let resourceFactory: ImageImgurUploadResourceFactory
    private let imageName: String
    private let imageTitle: String
    private let image: UIImage
    
    init(service: ImageUpLoadingRequests, resourceFactory: ImageImgurUploadResourceFactory, imageName: String, imageTitle: String, image: UIImage) {
        self.service = service
        self.resourceFactory = resourceFactory
        self.image = image
        self.imageTitle = imageTitle
        self.imageName = imageName
    }
    
    override func main() {
        if isCancelled == true { return }
        service.performUpLoadImage(name: imageName, title: imageTitle, image: image, resFactory: resourceFactory, complition: { [weak self] (data) in
            if self?.isCancelled == true { return }
            self?.data = data
            if let loadingCompleteHandler = self?.loadingCompleteHandler {
                DispatchQueue.main.async {
                    loadingCompleteHandler(data)
                }
            }
        }) { [weak self] (error) in
            if self?.isCancelled == true { return }
            if let errorHandler = self?.loadingErrorHandler {
                DispatchQueue.main.async {
                    errorHandler(ImageUploaderError(code: .main, underlying: error))
                }
            }
        }
        
    }
}
