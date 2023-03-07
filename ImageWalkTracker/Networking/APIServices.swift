//
//  APIServices.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

class APIServices {
    static let shared = APIServices()
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: configuration)
    }()
    
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickerAPIServices.photos(from: jsonData)
    }
    
    func fetchPhotos(from url: URL, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                let result = self.processPhotosRequest(data: data, error: error)
                completion(result)
            }
        }

        task.resume()
    }
}
