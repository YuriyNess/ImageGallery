//
//  ImageImgurUploadResourceFactory.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

enum ImgurApiError: Error {
    case upload(message: String)
    case parsing
}

final class ImageImgurUploadResourceFactory {
    
    private let clientId = "530f884ed46bf57"
    private let clientSecret = "3096a90846f61900d2faaff8753de47f36d8a6e4"
    private let url = "https://api.imgur.com/3/upload"
    
    func resource(imageName: String, imageTitle: String, image: UIImage) -> Resource<Result<String, ImgurApiError>>? {
        guard let url = URL(string: url) else { return nil }
        let headers = ["Authorization": "Client-ID \(clientId)", "Content-Type": "application/json; charset=utf-8"]
        let imageData = image.pngData()!.base64EncodedString(options: .lineLength64Characters)
        let params = ["image": imageData, "name": imageName, "title": imageTitle, "type":"base64"] as [String : Any]
        
        return try! ResourceBuilder<Result<String, ImgurApiError>>().with(url: url)
            .with(headers: headers)
            .with(params: params)
            .with(parse: { (response) -> Result<String, ImgurApiError> in
                guard let response = response as? [String: Any], let imageDic = response["data"] as? [String:Any] else { return .failure(.parsing) }
                if let responseError = imageDic["error"] as? [String:Any] {
                    let message = responseError["message"] as? String ?? ""
                    let errorCode = responseError["status"] as? String ?? ""
                    return .failure(.upload(message: "\(message) code:\(errorCode)"))
                } else {
                    let link = imageDic["link"] as? String ?? ""
                    return .success(link)
                }
            }).build(.JSON)
    }
}
