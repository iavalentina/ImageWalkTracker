//
//  Photos.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

struct Photos {
    public let photos: [Photo]
}

extension Photos: Decodable {
    enum RootCodingKeys: String, CodingKey {
        case photosContainer = "photos"
    }

    enum PhotosCodingKeys: String, CodingKey {
        case photos = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let rootObject = try decoder.container(keyedBy: RootCodingKeys.self)
        
        let photosContainer = try rootObject.nestedContainer(keyedBy: PhotosCodingKeys.self, forKey: .photosContainer)
        photos = try photosContainer.decode([Photo].self, forKey: .photos)
    }
}
