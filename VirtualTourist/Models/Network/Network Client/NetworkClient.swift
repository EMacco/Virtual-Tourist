//
//  NetworkClient.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import UIKit

class NetworkClient {
    
    private static var currentDownloads = [URLSessionDataTask]()
    
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/"
        
        case fetchImages
        
        var stringValue: String {
            switch self {
            case .fetchImages:
                return Endpoints.base
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func fetchLocationImages(pin: Pin, page: Int, completion: @escaping(Photos?, Error?) -> Void) {
        cancelOngoingDownloads()
        let params = FlickrParams.generateParams(from: pin, page: page)
        
        let _ = taskForGETRequest(url: Endpoints.fetchImages.url, params: params, responseType: FlickrPhotoResponse.self) { (response, error) in
            if let response = response {
                completion(response.value, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(url: URL, completion: @escaping(UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
        currentDownloads.append(task)
    }
    
    class private func cancelOngoingDownloads() {
        for task in currentDownloads {
            task.cancel()
        }
        currentDownloads = []
    }
    
    class private func taskForGETRequest<ResponseType: Decodable>(url: URL, params: [String: String], responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        let url = addParams(to: url, params: params)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    private class func addParams(to url: URL, params: [String: String]) -> URL {
        if var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponent.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            return urlComponent.url ?? url
        }
        return url
    }
}
