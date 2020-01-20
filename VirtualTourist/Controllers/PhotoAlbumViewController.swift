//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import ProgressHUD

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var region: MKCoordinateRegion!
    var pin: Pin!
    let photoAlbumCellIdentifier = "PhotoAlbumCollectionViewCell"
    var dataController: DataController! = DataController.shared
    var travelMapDelegate: TravelMapViewDelegate!
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    private var blockOperations: [BlockOperation] = []
    let imagePreviewVCIdentifier = "imagePreviewVC"
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.objectID)-photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        mapView.setRegion(region, animated: true)
        
        addShadow(to: backBtn)
        addShadow(to: trashBtn)
        addShadow(to: refreshBtn)
        
        configureAnnotation()
        if pin.totalCollections == -1 {
            collectionView.setEmptyMessage("No images found for this location")
        } else {
            if pin.photos?.count == 0 {
                fetchPinImages(page: 1)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in indexPaths {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
            collectionView.reloadItems(at: indexPaths)
        }
        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: false)
//            tableView.reloadRows(at: [indexPath], with: .fade)
//        }
    }
    
    func addShadow(to button: UIButton) {
        button.dropShadow(color: .black, opacity: 0.5, offSet: .zero, radius: 20.0, scale: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fetchedResultsController = nil
    }
    
    // MARK:- Fetch location Images
    func fetchPinImages(page: Int) {
        ProgressHUD.show("Loading...", interaction: false)
        NetworkClient.fetchLocationImages(pin: pin, page: page, completion: handleFlickrImagesResponse(value:error:))
    }
    
    func handleFlickrImagesResponse(value: Photos?, error: Error?) {
        if let error = error {
            collectionView.setEmptyMessage("Error fetching images")
            return ProgressHUD.showError(error.localizedDescription)
        }
        
        ProgressHUD.dismiss()
        guard let value = value else { return }
        if value.photos.count == 0 {
            collectionView.setEmptyMessage("No images found for this location")
            pin.totalCollections = -1
            try? dataController.viewContext.save()
        } else {
            collectionView.restore()
            if let total = Int16(value.total) {
                /// calculate page number since api returns total number of pictures and current page
                pin = CoreDataHelper.updateLocationCollectionSize(pin: pin, total: total, page: value.page)
            }
            
            for photo in value.photos {
                let newPhoto = CoreDataHelper.addPhoto(pin: pin, urlString: photo.url)
                fetchImageData(newPhoto)
            }
        }
    }
    
    func fetchImageData(_ photo: Photo?) {
        guard let url = photo?.url, let photo = photo else { return }
        NetworkClient.downloadImage(url: url) { image in
            CoreDataHelper.updatePhotoImageData(photo, image: image)
        }
    }
    
    func configureAnnotation() {
        let annotation = PinAnnotation(to: pin)
        mapView.addAnnotation(annotation)
        mapView.setCenter(CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), animated: true)
    }
    
    // MARK:- Refresh Collection
    @IBAction func refreshBtnClicked(_ sender: UIButton) {
        let currentPage = Int(pin.currentCollection)
        let total = Int(pin.totalCollections)
        var nextPage = currentPage + 1
        
        /// the user wants to confirm that no new image has been added to the server since last refresh
        if (total <= 0) { nextPage = 1  }
        
        clearCurrentCollection()
        if nextPage == total + 1 {
            fetchPinImages(page: 1)
        } else {
            fetchPinImages(page: nextPage)
        }
    }
    
    func clearCurrentCollection() {
        guard let photos = pin.photos else { return }
        for photo in photos {
            dataController.viewContext.delete(photo as! NSManagedObject)
        }
    }
    
    
    // MARK:- Delete Pin Methods
    @IBAction func deletePinClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete this location including all saved images?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.deletePin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deletePin() {
        travelMapDelegate.deletePin(pin)
        CoreDataHelper.delete(pin)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
}

// MARK:- CollectionView Delegate and DataSource
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAlbumCellIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.photo = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSideLength = (collectionView.frame.width/3) - 1
        return CGSize(width: cellSideLength, height: cellSideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: imagePreviewVCIdentifier) as! ImagePreviewViewController
        controller.modalPresentationStyle = .fullScreen
        controller.photo = fetchedResultsController.object(at: indexPath)
        self.present(controller, animated: true, completion: nil)
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

// MARK:- NSFetchedResultController Delegate
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let op: BlockOperation
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView.insertItems(at: [newIndexPath]) }
        case .delete:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.collectionView.deleteItems(at: [indexPath]) }
        case .move:
            guard let indexPath = indexPath,  let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.collectionView.moveItem(at: indexPath, to: newIndexPath) }
        case .update:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.collectionView.reloadItems(at: [indexPath]) }
        default:
            op = BlockOperation()
        }

        blockOperations.append(op)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let op: BlockOperation
        switch type {
        case .insert:
            op = BlockOperation { self.collectionView!.insertSections(IndexSet(integer: sectionIndex)) }
        case .update:
            op = BlockOperation { self.collectionView!.reloadSections(IndexSet(integer: sectionIndex)) }
        case .delete:
            op = BlockOperation { self.collectionView!.deleteSections(IndexSet(integer: sectionIndex)) }
        default:
            op = BlockOperation()
        }
        
        blockOperations.append(op)
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
}
