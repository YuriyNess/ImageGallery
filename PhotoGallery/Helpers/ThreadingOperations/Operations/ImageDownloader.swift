//
//  ImageDownloader.swift
//  FilmsOverviewApp
//
//  Created by YuriyFpc on 9/7/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

final class ImageDownloader: Operation {
    var data: Data?
    var loadingCompleteHandler: ((Data) ->Void)?
    var loadingErrorHandler: ((Error?) -> Void)?
    
    private let service: ImageLoadingRequests
    private let resourceFactory: ImageRresourceFactory
    private let url: String
    
    init(service: ImageLoadingRequests, resourceFactory: ImageRresourceFactory, url: String) {
        self.service = service
        self.resourceFactory = resourceFactory
        self.url = url
    }
    
    override func main() {
        if isCancelled == true { return }
        service.performLoadImage(url: url, resFactory: resourceFactory, complition: { [weak self] (data) in
            if self?.isCancelled == true { return }
            if let imageData = data {
                self?.data = imageData
                if let loadingCompleteHandler = self?.loadingCompleteHandler {
                    DispatchQueue.main.async {
                        loadingCompleteHandler(imageData)
                    }
                }
            } else {
                if let errorHandler = self?.loadingErrorHandler {
                    DispatchQueue.main.async {
                        errorHandler(ImageUploaderError(code: .main, systemMsg: "Empty data returned from server"))
                    }
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
