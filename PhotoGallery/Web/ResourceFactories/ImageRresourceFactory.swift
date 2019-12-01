//
//  ImageRresourceFactory.swift
//  UnsplashViewer
//
//  Created by YuriyFpc on 9/14/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

final class ImageRresourceFactory {
    func resource(url: String) -> Resource<Result<Data, ImageRresourceFactoryError>>? {
        guard let url = URL(string: url) else { return nil }
        return try! ResourceBuilder<Result<Data, ImageRresourceFactoryError>>().with(url: url)
            .with(parse: { (data) -> Result<Data, ImageRresourceFactoryError> in
                if let data = data as? Data {
                    return .success(data)
                } else {
                    return .failure(ImageRresourceFactoryError(code: .parsing))
                }
            }).build(.Data)
    }
}
