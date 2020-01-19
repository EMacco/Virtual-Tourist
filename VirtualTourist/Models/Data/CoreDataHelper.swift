//
//  CoreDataHelper.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 20/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import MapKit
import CoreData

struct CoreDataHelper {
    private static let dataController: DataController! = DataController.shared
    
    static func addPin(to location: CLLocationCoordinate2D, title: String?) -> Pin? {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = location.latitude
        pin.longitude = location.longitude
        pin.name = title ?? "Unknown location"
        try? dataController.viewContext.save()
        return pin
    }
    
    static func updateLocationCollectionSize(pin: Pin, total: Int16, page: Int) -> Pin {
        pin.totalCollections = Int16(round(Double(total) / (Double(FlickrParams.perPage.rawValue) ?? 1)))
        pin.currentCollection = Int16(page)
        try? dataController.viewContext.save()
        return pin
    }
    
    static func addPhoto(pin: Pin, urlString: String) -> Photo? {
        let photo = Photo(context: dataController.viewContext)
        photo.url = URL(string: urlString)
        photo.pin = pin
        try? dataController.viewContext.save()
        return photo
    }
    
    static func updatePhotoImageData(_ photo: Photo, image: UIImage?) {
        let photoID = photo.objectID
        let backgroundContext: NSManagedObjectContext! = self.dataController.backgroundContext
        backgroundContext.perform {
            let backgroundPhoto = backgroundContext.object(with: photoID) as! Photo
            backgroundPhoto.image = image?.pngData()
            try? backgroundContext.save()
        }
    }
}
