//
//  UImage+URL.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

extension UIImage {
    convenience init?(url: URL) async {
        guard let (data, _) = try? await URLSession.shared.data(for: URLRequest(url: url)) else {
            return nil
        }
        self.init(data: data)
    }
}
