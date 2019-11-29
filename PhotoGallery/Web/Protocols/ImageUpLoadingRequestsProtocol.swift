//
//  ImageUpLoadingRequestsProtocol.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

protocol ImageUpLoadingRequests {
    func performUpLoadImage(name: String, title: String, image: UIImage, resFactory: ImageImgurUploadResourceFactory, complition: @escaping (String)-> Void, errorComplition: @escaping (Error?) -> Void)
}
