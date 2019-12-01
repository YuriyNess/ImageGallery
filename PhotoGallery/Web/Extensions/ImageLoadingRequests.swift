//
//  ImageLoadingRequests.swift
//  UnsplashViewer
//
//  Created by YuriyFpc on 9/14/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

let dataCache = NSCache<NSString, AnyObject>()

extension Webservice: ImageLoadingRequests {
    func performLoadImage(url: String, resFactory: ImageRresourceFactory, complition: @escaping (Data?)-> Void, errorComplition: @escaping (Error?) -> Void) {
        guard let resource = resFactory.resource(url: url) else { return }
        if let data = dataCache.object(forKey: resource.url.absoluteString as NSString) as? Data {
            complition(data)
        } else {
            get(resource: resource, completion: { (response) in                
                if let r = response {
                    switch r {
                    case .success(let data):
                        dataCache.setObject(data as AnyObject, forKey: resource.url.absoluteString as NSString)
                        complition(data)
                    case .failure(let error):
                        errorComplition(ImageLoadingRequestsError(code: .performUpLoadImage, underlying: error))
                    }
                }
                
            }) { (error) in
                errorComplition(error)
            }
        }
    }
}
