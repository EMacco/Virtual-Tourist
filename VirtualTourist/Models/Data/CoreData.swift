//
//  CoreDataHelper.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 20/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import MapKit
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    private static let dataController: DataController! = DataController.shared
    private init() {}
    
    class func addPin(to location: CLLocationCoordinate2D, title: String?) -> Pin {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = location.latitude
        pin.longitude = location.longitude
        pin.name = title ?? "Unknown location"
        try? dataController.viewContext.save()
        return pin
    }
}
