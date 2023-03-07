//
//  FlickerAPI.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

struct FlickerConfiguration {
    static let apiKey = "d9293cfc66d0cc477f873735df806b62"
    static let fetchPhotosBaseURL = "https://api.flickr.com/services/rest"
    static let fetchImageBaseUrl = "https://live.staticflickr.com"
}

struct FlickerAPIServices {
    
    static func flickrURL(baseURL: String,
                          basePath: String? = nil,
                          requestPath: String? = nil,
                          extraParameters: [String: String]? = nil) -> URL {
        var components = [baseURL]
        if let basePath = basePath {
            components.append(basePath)
        }
        
        if let requestPath = requestPath {
            components.append(requestPath)
        }

        let urlString = components.lazy.joined(separator: "/")
        
        guard var urlComponents = URLComponents(string: urlString) else {
            preconditionFailure("Malformed request")
        }
        guard let queryItems = extraParameters else {
            if let url = urlComponents.url {
                return url
            }
            preconditionFailure("Malformed request")
        }

        var currentQueryItems = urlComponents.queryItems
        let urlQueryItems = queryItems.keys.sorted().map {
            return URLQueryItem(name: $0, value: queryItems[$0])
        }
        
        if var currentQueryItems = currentQueryItems {
            currentQueryItems.append(contentsOf: urlQueryItems)
        } else {
            currentQueryItems = urlQueryItems
        }
        
        urlComponents.queryItems = currentQueryItems
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        if let url = urlComponents.url {
            print("Photos URL =", url)
            return url
        }
        preconditionFailure("Malformed request")
    }
    
    static func photosSearchURL(extraParameters: [String: String]) -> URL {
        let parameters = recentPhotosParamaters.reduce(into: extraParameters) { (r, e) in
            r[e.0] = e.1
        }
        
        return FlickerAPIServices.flickrURL(baseURL: FlickerConfiguration.fetchPhotosBaseURL,
                                            extraParameters: parameters)
    }

    static func photos(from data: Data) -> Result<[Photo], Error> {
        do {
            let flickrResponse = try JSONDecoder().decode(Photos.self, from: data)
            return .success(flickrResponse.photos)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private
    
    private static let recentPhotosParamaters: [String: String] = [
        "api_key": FlickerConfiguration.apiKey,
        "method": "flickr.photos.search",
        "format": "json",
        "nojsoncallback": "1",
        "per_page": "10",
        "radius": "0.5",
        "geo_context": "2"
    ]
}
