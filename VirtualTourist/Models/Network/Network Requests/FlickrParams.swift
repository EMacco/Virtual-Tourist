//
//  FlickrParams.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

enum FlickrParams: String {
    case method = "flickr.photos.search"
    case key = "" // Add API Key
    case format = "json"
    case noJSONCallback = "1"
    case perPage = "100"
    case extras = "url_m"
    case page
    
    static func generateParams(from pin: Pin, page: Int) -> [String: String] {
        return [
            FlickrKeys.text.rawValue: pin.name ?? "",
            FlickrKeys.method.rawValue: FlickrParams.method.rawValue,
            FlickrKeys.format.rawValue: FlickrParams.format.rawValue,
            FlickrKeys.extras.rawValue: FlickrParams.extras.rawValue,
            FlickrKeys.latitude.rawValue: String(pin.latitude),
            FlickrKeys.longitude.rawValue: String(pin.longitude),
            FlickrKeys.page.rawValue: String(page),
            FlickrKeys.apiKey.rawValue: FlickrParams.key.rawValue,
            FlickrKeys.perPage.rawValue: FlickrParams.perPage.rawValue,
            FlickrKeys.noJSONCallback.rawValue: FlickrParams.noJSONCallback.rawValue
        ]
    }
}

enum FlickrKeys: String {
    case text
    case page
    case method
    case radius
    case format
    case extras
    case latitude = "lat"
    case longitude = "lon"
    case apiKey = "api_key"
    case perPage = "per_page"
    case noJSONCallback = "nojsoncallback"
}
