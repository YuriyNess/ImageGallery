//
//  ImageLoadOperations.swift
//  FilmsOverviewApp
//
//  Created by YuriyFpc on 9/7/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

final class ImageLoadOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()

    private let operationsFactory: OperationsFactory
    private let service: ImageLoadingRequests
    private let resourceFactory: ImageRresourceFactory
    
    init(operationsFactory: OperationsFactory, service: ImageLoadingRequests, resourceFactory: ImageRresourceFactory) {
        self.operationsFactory = operationsFactory
        self.service = service
        self.resourceFactory = resourceFactory
    }
    
    func startImageLoadOperation(url: String, indexPath: IndexPath, complition: ((Data?)->Void)?, errorComplition: ((Error?)->Void)?) {
        guard let operation = downloadsInProgress[indexPath] as? ImageDownloader else {
            let operation = createImageLoadOperation(url: url, indexPath: indexPath)
            operation.loadingCompleteHandler = { [weak self] data in
                self?.purgeOperation(indexPath: indexPath)
                complition?(data)
            }
            operation.loadingErrorHandler = { [weak self] error in
                self?.purgeOperation(indexPath: indexPath)
                errorComplition?(ImageLoadOperationsError(code: .startImageLoadOperation, underlying: error))
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
        downloadsInProgress.removeValue(forKey: indexPath)
    }
    
    @discardableResult
    private func createImageLoadOperation(url: String, indexPath: IndexPath) -> ImageDownloader {
        let operation = operationsFactory.createImageLoadOperation(url: url, service: service, resourceFactory: resourceFactory)
        downloadQueue.addOperation(operation)
        downloadsInProgress[indexPath] = operation
        return operation
    }
}
