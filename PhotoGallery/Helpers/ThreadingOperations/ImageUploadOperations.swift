//
//  ImageUploadOperations.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation
import UIKit

final class ImageUploadOperations {
    lazy var uploadsInProgress: [IndexPath: Operation] = [:]

    lazy var uploadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Upload queue"
        return queue
    }()
    
    private let operationsFactory: OperationsFactory
    private let service: ImageUpLoadingRequests
    private let resourceFactory: ImageImgurUploadResourceFactory
    private var isSequentialUpload: Bool = false
    private var previousOperation: Operation?
    
    init(operationsFactory: OperationsFactory, service: ImageUpLoadingRequests, resourceFactory: ImageImgurUploadResourceFactory, isSequentialUpload: Bool) {
        self.operationsFactory = operationsFactory
        self.service = service
        self.resourceFactory = resourceFactory
        self.isSequentialUpload = isSequentialUpload
        uploadQueue.maxConcurrentOperationCount = isSequentialUpload == true ? 1 : 30
    }
    
    func startImageUpLoadOperation(imageName: String, imageTitle: String, image: UIImage, indexPath: IndexPath, complition: ((Any?)->Void)?, errorComplition: ((Error?)->Void)?) {
        guard let operation = uploadsInProgress[indexPath] as? ImageDownloader else {
            let operation = createImageUpLoadOperation(indexPath: indexPath, imageName: imageName, imageTitle: imageTitle, image: image)
            operation.loadingCompleteHandler = { [weak self] data in
                self?.purgeOperation(indexPath: indexPath)
                complition?(data)
            }
            operation.loadingErrorHandler = { [weak self] error in
                self?.purgeOperation(indexPath: indexPath)
                errorComplition?(ImageUploadOperationsError(code: .startImageUpLoadOperation, underlying: error))
            }
            return
        }
        if let data = operation.data {
            complition?(data)
            purgeOperation(indexPath: indexPath)
        } else {
            operation.loadingCompleteHandler = complition
        }
    }
    
    func purgeOperation(indexPath: IndexPath) {
        uploadsInProgress.removeValue(forKey: indexPath)
    }
    
    func isUploadInProgress(indexPath: IndexPath) -> Bool {
        return uploadsInProgress[indexPath] == nil ? false : true
    }
    
    @discardableResult
    private func createImageUpLoadOperation(indexPath: IndexPath, imageName: String, imageTitle: String, image: UIImage) -> ImageUploader {
        let operation = operationsFactory.createImageUpLoadOperation(imageName: imageName, imageTitle: imageTitle, image: image, service: service, resourceFactory: resourceFactory)
        uploadQueue.addOperation(operation)
        uploadsInProgress[indexPath] = operation
        return operation
    }
    
}
