//
//  Plist.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import MapKit

class Plist {
    static let shared = Plist()
    private init() {
        mapCameraState = retrieveCameraState()
    }
    
    var mapCameraState: MKCoordinateRegion? {
        didSet {
            saveCameraRegion()
        }
    }
    
    private func saveCameraRegion() {
        if let region = mapCameraState {
            let regionDict = [
                CameraRegionKeys.latitude.rawValue: region.center.latitude,
                CameraRegionKeys.longitude.rawValue: region.center.longitude,
                CameraRegionKeys.latitudeDelta.rawValue: region.span.latitudeDelta,
                CameraRegionKeys.longitudeDelta.rawValue: region.span.longitudeDelta
            ]
            UserDefaults.standard.set(regionDict, forKey: Keys.cameraRegion.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func retrieveCameraState() -> MKCoordinateRegion? {
        if let region = UserDefaults.standard.dictionary(forKey: Keys.cameraRegion.rawValue) {
            
            if
                let latitude: CLLocationDegrees = region[CameraRegionKeys.latitude.rawValue] as? Double,
                let longitude: CLLocationDegrees = region[CameraRegionKeys.longitude.rawValue] as? Double,
                let latitudeDelta: CLLocationDegrees = region[CameraRegionKeys.latitudeDelta.rawValue] as? Double,
                let longitudeDelta: CLLocationDegrees = region[CameraRegionKeys.longitudeDelta.rawValue] as? Double {
                return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude) , span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
            }
            
        }
        return nil
    }
    
}

extension Plist {
    private enum Keys: String {
        case cameraRegion
    }

    private enum CameraRegionKeys: String {
        case latitude
        case longitude
        case latitudeDelta
        case longitudeDelta
    }
}
