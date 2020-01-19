//
//  FlickrPhotosResponse.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct FlickrPhotoResponse: Decodable {
    let stat: String
    let value: Photos
    
    enum CodingKeys: String, CodingKey {
        case stat
        case value = "photos"
    }
}
