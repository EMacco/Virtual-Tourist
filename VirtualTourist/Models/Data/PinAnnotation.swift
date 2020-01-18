//
//  PinAnnotation.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import MapKit

final class PinAnnotation: NSObject, MKAnnotation {
    let pin: Pin
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(to pin: Pin) {
        self.pin = pin
        self.title = pin.name
        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        super.init()
    }
}
