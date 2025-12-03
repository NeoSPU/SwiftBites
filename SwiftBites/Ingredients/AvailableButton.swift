// AvailableButton.swift
// SwiftBites
//
// Created by Alex Rublov on 03/12/2025.
// Copyright © 2025 Alex Rublov. All rights reserved.
//
// ========================================================

import SwiftUI

struct AvailableButton: View {
    @Binding var isAvailable: Bool
    var onToggle: ((Bool) -> Void)? = nil
    var body: some View {
        Button(action: {
            isAvailable.toggle()
            onToggle?(isAvailable)
        }, label:
                { isAvailable ?
            Image(systemName: "checkmark.circle")
                .symbolVariant(isAvailable ? .fill : .none)
                .imageScale(.large)
                .foregroundStyle(.green) :
            Image(systemName: "checkmark.circle")
                .symbolVariant(isAvailable ? .fill : .none)
                .imageScale(.large)
                .foregroundStyle(.gray)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        AvailableButton(isAvailable: .constant(true))
        AvailableButton(isAvailable: .constant(false))
        AvailableButton(isAvailable: .constant(true), onToggle: { newValue in
            print("Toggled to: \(newValue)")
        })
    }
}
