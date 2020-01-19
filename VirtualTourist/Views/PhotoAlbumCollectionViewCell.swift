//
//  PhotoAlbumCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    var photo: Photo! {
        didSet {
            loadCellImage()
        }
    }
    @IBOutlet weak var pinImageView: UIImageView!
    
    func loadCellImage() {
        if let imageData = photo.image {
            self.pinImageView.image = UIImage(data: imageData)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pinImageView.image = #imageLiteral(resourceName: "placeholderImage")
    }
}
