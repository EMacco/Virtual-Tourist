//
//  FlickerImage.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct FlickrImage: Decodable {
    let id: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "url_m"
    }
}
