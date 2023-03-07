//
//  ActivityPhotoListFormatter.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

enum ActivityPhotoListFormatter {
    static func photoURL(from photo: Photo) -> URL {
        let photoSizeSuffix = "c"
        let photoPathComponents: [String] = [photo.id, photo.secretKey, photoSizeSuffix]
        let baseURL = FlickerConfiguration.fetchImageBaseUrl
        var requestPath = photoPathComponents.joined(separator: "_")
        requestPath += ".jpg"
        let photoUrl = FlickerAPIServices.flickrURL(baseURL: baseURL,
                                                    basePath: photo.serverId,
                                                    requestPath: requestPath)
        return photoUrl
    }
}
