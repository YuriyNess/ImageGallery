//
//  GalleryModel.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation
import Photos
import RealmSwift

enum GalleryModelErrorCode: Int, BaseErrorCode {
    case upload = 0
}

class GalleryModelError: BaseError<GalleryModelErrorCode> {
    override func domainShortname() -> String {
        return "GM"
    }
}

class GalleryModel {
    
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var updateOnDataLoad: (()->Void)?
    var updateOnLoadingState: ((IndexPath)->Void)?
    
    private var service = Webservice()
    private let realm = try! Realm()
    private lazy var uplodOperations: ImageUploadOperations = ImageUploadOperations(operationsFactory: OperationsFactory(), service: service, resourceFactory: ImageImgurUploadResourceFactory(), isSequentialUpload: true)
    
    func load() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                DispatchQueue.main.async {
                    self.updateOnDataLoad?()
                }
            default:
                print("Image data has not loaded")
            }
        }
    }
    
    func upload(name: String, title: String, image: UIImage, indexPath: IndexPath, complition: ((Any)->Void)?, errorComplition: ((Error?)->Void)?) {
        uplodOperations.startImageUpLoadOperation(imageName: name, imageTitle: title, image: image, indexPath: indexPath, complition: complition, errorComplition: { error in
            errorComplition?(GalleryModelError(code: .upload, underlying: error))
        })
        updateOnLoadingState?(indexPath)
    }
    
    func isUploadInProgress(indexPath: IndexPath) -> Bool {
        return uplodOperations.isUploadInProgress(indexPath: indexPath)
    }
    
    func savePersistent(link: String) {
        let newLink = Link()
        newLink.url = link
        try! realm.write {
            realm.add(newLink)
        }
    }
    
    func loadPersistentLinks() -> Results<Link> {
        return realm.objects(Link.self).sorted(byKeyPath: "date", ascending: false)
    }
}

extension UIImageView{
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            @unknown default:
                break
            }
            self.image = image
        }
    }
}
