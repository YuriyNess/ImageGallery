//
//  ImageCollectionViewCell.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setState(isUploadInProgress: Bool) {
        if isUploadInProgress {
            activity.isHidden = false
            activity.startAnimating()
        } else {
            activity.isHidden = true
            activity.stopAnimating()
        }
    }
}
