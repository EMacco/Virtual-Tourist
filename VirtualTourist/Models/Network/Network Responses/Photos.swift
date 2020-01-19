//
//  Photos.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    let photos: [FlickrImage]
    let page: Int
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
        case page
        case total
    }
}
