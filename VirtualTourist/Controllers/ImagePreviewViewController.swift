//
//  ImagePreviewViewController.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 20/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    var photo: Photo!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadow(to: backBtn)
        addShadow(to: deleteBtn)
        
        if let imageData = photo.image {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = #imageLiteral(resourceName: "placeholderImage")
        }
    }

    @IBAction func deleteImageBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image from collection?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.deleteImage()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteImage() {
        CoreDataHelper.delete(photo)
        dismiss(animated: true, completion: nil)
    }
    
    func addShadow(to button: UIButton) {
        button.dropShadow(color: .black, opacity: 0.5, offSet: .zero, radius: 20.0, scale: true)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
