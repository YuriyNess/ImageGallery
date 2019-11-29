//
//  ViewController.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/26/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit
import Alamofire

class GalleryViewController: UIViewController {
    
    private struct Constants {
        static let cellId = "ImageCollectionViewCell"
    }
    
    @IBOutlet weak var collcetionView: UICollectionView!
    private let model: GalleryModel = GalleryModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Links", style: .plain, target: self, action: #selector(handlebbItemTap)), animated: false)
        setupModelComplitions()
        model.load()
    }
    
    @objc
    private func handlebbItemTap() {
        let vc = LinksViewController()
        vc.links = model.loadPersistentLinks()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupModelComplitions() {
        model.updateOnDataLoad = { [weak self] in
            self?.collcetionView.reloadData()
        }
        model.updateOnLoadingState = { [weak self]  index in
            self?.collcetionView.reloadItems(at: [index])
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! ImageCollectionViewCell
        let asset = model.allPhotos?.object(at: indexPath.row)
        cell.imageView.fetchImage(asset: asset!, contentMode: .aspectFill, targetSize: cell.imageView.frame.size)
        cell.setState(isUploadInProgress: model.isUploadInProgress(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell, let image = cell.imageView.image, model.isUploadInProgress(indexPath: indexPath) == false else { return }
        
        model.upload(name: "", title: "", image: image, indexPath: indexPath, complition: { [weak self] (linkStr) in
            if let link = linkStr as? String {
                self?.model.savePersistent(link: link)
            }
                collectionView.reloadItems(at: [indexPath])
            }) { [weak self] error in
            if let error = error as? ImgurApiError, let _ = collectionView.cellForItem(at: indexPath) {
                if case let ImgurApiError.upload(message) = error {
                    self?.showAlert(title: "Error", message: message)
                }
            } else {
                self?.showAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if view.frame.width > view.frame.height {
            return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.width / 5)
        } else {
            return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
