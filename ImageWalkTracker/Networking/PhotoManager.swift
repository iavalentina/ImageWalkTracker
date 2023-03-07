//
//  PhotoManager.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import Foundation
import UIKit

class PhotoManager {
    
    static let shared = PhotoManager()
    
    private init() {}
    
    static let localPhotosDirectory: String? = {
        guard let localDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let photosDirectoryPath = String(format: "%@/%@", localDirectory, "FlickerPhotos")
        
        do {
            if !FileManager.default.fileExists(atPath: photosDirectoryPath) {
                try FileManager.default.createDirectory(atPath: photosDirectoryPath,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
            }
        } catch {
            return FileManager.default.fileExists(atPath: photosDirectoryPath) ? photosDirectoryPath : nil
        }
        
        return photosDirectoryPath
    }()
    
    func checkIfSaved(name: String) -> Bool {
        guard let filePath = getFilePath(name) else { return false }
        
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func saveToDisk(name: String, image: UIImage) {
        guard let filePath = getFilePath(name), let data = image.jpegData(compressionQuality: 1) else { return }
        
        do {
            try data.write(to: URL(fileURLWithPath: filePath))
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    private func getFilePath(_ name: String) -> String? {
        guard let documentsDirectory = PhotoManager.localPhotosDirectory else { return nil }
        
        return String(format: "%@/%@.jpg", documentsDirectory, name)
    }
    
    func loadFromDisk(from filePath: String) -> UIImage? {
        return UIImage(contentsOfFile: filePath)
    }
    
    func getAllSavedPhotoPaths() -> [String] {
        guard let documentsDirectory = PhotoManager.localPhotosDirectory else { return [] }
        let documentUrl = URL(fileURLWithPath: documentsDirectory)
        let items = try! FileManager.default.contentsOfDirectory(at: documentUrl,
                                                                 includingPropertiesForKeys: [.creationDateKey])
        
        return items.map { url in
            (url.path,
             (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
        }
        .sorted(by: { $0.1 > $1.1 })
        .map { $0.0 }
    }
}
