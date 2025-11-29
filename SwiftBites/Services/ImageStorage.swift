// ImageStorage.swift
// SwiftBites
//
// Created by Alex Rublov on 23/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import Foundation
import UIKit


struct ImageStorage {
    static let shared = ImageStorage()
    
    
    let folder: URL = {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = base.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()
    
    
    func save(image: UIImage, id: UUID) throws -> String {
        let url = folder.appendingPathComponent("\(id.uuidString).jpg")
        guard let data = image.jpegData(compressionQuality: 0.85) else {
            throw NSError(domain: "ImageStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode image to JPEG"])
        }
        try data.write(to: url, options: .atomic)
        return url.lastPathComponent
    }
    
    
    func loadImage(named filename: String) -> UIImage? {
        let url = folder.appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }
    
    
    func delete(named filename: String) throws {
        let url = folder.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
