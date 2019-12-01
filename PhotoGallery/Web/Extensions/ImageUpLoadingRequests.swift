//
//  ImageUpLoadingRequests.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

extension Webservice: ImageUpLoadingRequests {
    func performUpLoadImage(name: String, title: String, image: UIImage, resFactory: ImageImgurUploadResourceFactory, complition: @escaping (String)-> Void, errorComplition: @escaping (Error?) -> Void) {
        guard let res = resFactory.resource(imageName: name, imageTitle: title, image: image) else { return }
        post(resource: res, completion: { (response) in
            if let r = response {
                switch r {
                case .success(let link):
                    complition(link)
                case .failure(let error):
                    errorComplition(ImageUpLoadingRequestsError(code: .performUpLoadImage, underlying: error))
                }
            }
        }) { (error) in
            errorComplition(ImageUpLoadingRequestsError(code: .performUpLoadImage, underlying: error))
        }
    }
}
