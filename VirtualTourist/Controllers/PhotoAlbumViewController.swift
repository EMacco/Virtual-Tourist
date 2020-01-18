//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var region: MKCoordinateRegion!
    var pin: Pin!
    let photoAlbumCellIdentifier = "PhotoAlbumCollectionViewCell"
    var dataController: DataController!
    var travelMapDelegate: TravelMapViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(region, animated: true)
        backBtn.dropShadow(color: .black, opacity: 0.5, offSet: .zero, radius: 20.0, scale: true)
        trashBtn.dropShadow(color: .black, opacity: 0.5, offSet: .zero, radius: 20.0, scale: true)
        
        configureAnnotation()
    }
    
    func configureAnnotation() {
        let annotation = PinAnnotation(to: pin)
        mapView.addAnnotation(annotation)
        mapView.setCenter(CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), animated: true)
    }
    
    @IBAction func deletePinClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete this location including all saved images?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.deletePin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deletePin() {
        dataController.viewContext.delete(pin)
        travelMapDelegate.deletePin(pin)
        try? dataController.viewContext.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK:- CollectionView Delegate and DataSource
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAlbumCellIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        return cell
    }
}

// MARK:- MapKit Extension
extension PhotoAlbumViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
        pinView?.isSelected = true
        return pinView
    }
}
