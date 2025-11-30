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
    
    
    func save(imageData: Data?, id: UUID) throws -> String {
        let url = folder.appendingPathComponent("\(id.uuidString).png")
        guard let imageData, let data = UIImage(data: imageData)?.pngData() else {
            throw NSError(domain: "ImageStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode image to PNG"])
        }
        try data.write(to: url, options: .atomicWrite)
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

