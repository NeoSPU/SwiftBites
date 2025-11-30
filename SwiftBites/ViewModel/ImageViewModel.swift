// ImageViewModel.swift
// SwiftBites
//
// Created by Alex Rublov on 29/11/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================
import SwiftUI

struct ImageViewModel {
    
    private var imageName: String
    private var image: UIImage? {
        get {
            if let image = ImageStorage.shared.loadImage(named: imageName) {
                return image
            }
            return nil
        }
    }
}
