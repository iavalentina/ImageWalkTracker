//
//  Photo.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation

struct Photo: Sendable {
    public let id: String
    public let secretKey: String
    public let serverId: String
}

extension Photo: Decodable {
    enum RootCodingKeys: String, CodingKey {
        case secretKey = "secret"
        case serverId = "server"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let rootObject = try decoder.container(keyedBy: RootCodingKeys.self)
        
        id = try rootObject.decode(String.self, forKey: .id)
        secretKey = try rootObject.decode(String.self, forKey: .secretKey)
        serverId = try rootObject.decode(String.self, forKey: .serverId)
    }
}
