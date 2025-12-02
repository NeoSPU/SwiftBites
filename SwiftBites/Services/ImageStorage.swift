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
    
    enum ImageStorageError: LocalizedError {
        case noData
        case decodeFailed
        case encodeFailed
        case writeFailed(Error)

        var errorDescription: String? {
            switch self {
            case .noData:
                return "No image data provided."
            case .decodeFailed:
                return "Failed to decode image data."
            case .encodeFailed:
                return "Failed to encode image to desired format."
            case .writeFailed(let err):
                return "Failed to write image to disk: \(err.localizedDescription)"
            }
        }
    }
    
    let folder: URL = {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = base.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()

//    func save(imageData: Data?, id: UUID) throws -> String {
//        let url = folder.appendingPathComponent("\(id.uuidString)\(".jpg")")
//        guard let imageData else { throw ImageStorageError.noData }
//        guard let uiImage = UIImage(data: imageData) else { throw ImageStorageError.decodeFailed }
//        let encoded: Data?
//        encoded = uiImage.jpegData(compressionQuality: 0.9)
//        
//        guard let data = encoded else { throw ImageStorageError.encodeFailed }
//        do {
//            try data.write(to: url, options: .atomicWrite)
//        } catch {
//            throw ImageStorageError.writeFailed(error)
//        }
//        return url.lastPathComponent
//    }
    
    func save(imageData: Data?, id: UUID) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .utility) {
                do {
                    let url = folder.appendingPathComponent("\(id.uuidString).jpg")
                    guard let imageData else { throw ImageStorageError.noData }
                    guard let uiImage = UIImage(data: imageData) else { throw ImageStorageError.decodeFailed }
                    guard let data = uiImage.jpegData(compressionQuality: 0.9) else { throw ImageStorageError.encodeFailed }
                    do {
                        try data.write(to: url, options: .atomicWrite)
                    } catch {
                        throw ImageStorageError.writeFailed(error)
                    }
                    continuation.resume(returning: url.lastPathComponent)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
//    func save(imageData: Data?, id: UUID) throws -> String {
//        let url = folder.appendingPathComponent("\(id.uuidString).png")
//        guard let imageData, let data = UIImage(data: imageData)?.pngData() else {
//            throw NSError(domain: "ImageStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not encode image to PNG"])
//        }
//        try data.write(to: url, options: .atomicWrite)
//        return url.lastPathComponent
//    }
    
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

