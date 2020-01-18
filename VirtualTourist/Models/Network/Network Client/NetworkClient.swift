//
//  NetworkClient.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

class NetworkClient {
    
//    private static let key = "5b1d4190ae88ee47d3fa8b1a74b2855e"
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/"
        
        case fetchImages(lat: Double, lon: Double)
        
        var stringValue: String {
            switch self {
            case .fetchImages(let lat, let lon):
                
                return ""
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
//    class func updateLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, id: String, completion: @escaping(Bool, Error?) -> Void) {
//        let body = AddUserLocationRequest(uniqueKey: Auth.userId, firstName: Auth.user!.firstName, lastName: Auth.user!.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
//        taskForPOSTRequest(url: Endpoints.updateLocation(id: id).url, responseType: UpdateLocationResponse.self, body: body, udacityApi: false, method: "PUT") { response, error in
//            if let _ = response {
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
}
